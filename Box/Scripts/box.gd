class_name DialogueLabel
extends RichTextLabel

@export var _data_store: DataStore


func _ready() -> void:
	_data_store.data_loaded.connect(_on_data_loaded)
	_data_store.data_freed.connect(clear)


func _on_data_loaded():
	UIWatcher.watch(self, _data_store.entry_selected, _on_current_entry_changed)


func _on_current_entry_changed(entry: DialogueEntry) -> void:
	if entry == null or entry.current_dialogue == null:
		text = ""
	UIWatcher.watch(self, entry.current_dialogue_changed, _on_dialogue_changed)


func _on_dialogue_changed(dialogue: Dialogue) -> void:
	UIWatcher.watch(self, dialogue.content_changed, _on_dialogue_changed.bind(dialogue))
	var parsed_text = DialogueParser.parse(dialogue.content)
	if parsed_text.begins_with("*"):
		var lines: PackedStringArray = []
		for line in parsed_text.split("\n"):
			if line.begins_with("*"):
				var first_char = line.trim_prefix("*")[0]
				var result = "[table=2][cell]*%s[/cell][cell]%s[/cell][/table]" % [
					first_char,
					line.trim_prefix("*%s" % first_char),
				]
				lines.append(result)

		text = "\n".join(lines)
	else:
		text = parsed_text
