extends TextEdit
class_name OriginalDialogue
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
	UIWatcher.watch(self, entry.current_dialogue_changed, _on_dialogue_changed)


func _on_dialogue_changed(dialogue: Dialogue) -> void:
	text = dialogue.original_content
