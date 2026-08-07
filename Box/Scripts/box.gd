extends RichTextLabel
class_name DialogueLabel

@export var _data_store: DataStore


func _ready() -> void:
	_data_store.data_loaded.connect(_on_data_loaded)


func _on_data_loaded():
	UIWatcher.watch(self, _data_store.entry_selected, _on_current_entry_changed)


func _on_current_entry_changed(entry: DialogueEntry) -> void:
	if entry == null or entry.current_dialogue == null:
		text = ""
	UIWatcher.watch(self, entry.current_dialogue_changed, _on_dialogue_changed)


func _on_dialogue_changed(dialogue: Dialogue) -> void:
	UIWatcher.watch(self, dialogue.content_changed, _on_dialogue_changed.bind(dialogue))
	text = _data_store.current_entry.current_dialogue.content
	text = DialogueParser.parse(text)
