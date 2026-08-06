extends TextEdit
class_name OriginalDialogue
var _data_file: DataStore
var data_file: DataStore:
	get:
		return data_file
	set(value):
		if value == null:
			return
		_data_file = value
		_data_file.entry_selected.connect(_on_current_entry_changed)


func _on_current_entry_changed() -> void:
	if not _data_file.current_entry.current_dialogue_changed.is_connected(_on_dialogue_changed):
		_data_file.current_entry.current_dialogue_changed.connect(_on_dialogue_changed)


func _on_dialogue_changed() -> void:
	var current_dialogue := _data_file.current_entry.current_dialogue
	text = current_dialogue.original_content
