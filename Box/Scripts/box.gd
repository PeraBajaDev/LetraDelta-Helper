extends RichTextLabel
class_name DialogueLabel

var _data_file: DataStore
var data_file: DataStore:
	get:
		return _data_file
	set(value):
		if value == null:
			return
		_data_file = value
		UIWatcher.watch(self, _data_file.entry_selected, _on_current_entry_changed)


func _on_current_entry_changed(entry: DialogueEntry) -> void:
	if entry == null or entry.current_dialogue == null:
		text = ""
	UIWatcher.watch(self, entry.current_dialogue_changed, _on_dialogue_changed)


func _on_dialogue_changed(dialogue: Dialogue) -> void:
	UIWatcher.watch(self, dialogue.content_changed, _on_dialogue_changed)
	text = _data_file.current_entry.current_dialogue.content
	text = DialogueParser.parse(text)
