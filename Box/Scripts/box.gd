extends RichTextLabel
class_name DialogueLabel

var _data_file: DataFile
var data_file: DataFile:
	get:
		return data_file
	set(value):
		if value == null:
			return
		_data_file = value
		if not _data_file.current_entry_changed.is_connected(_on_current_entry_changed):
			_data_file.current_entry_changed.connect(_on_current_entry_changed)


func _on_current_entry_changed() -> void:
	if _data_file.current_entry == null or _data_file.current_entry.current_dialogue == null:
		text = ""
	if not _data_file.current_entry.current_dialogue_changed.is_connected(_on_dialogue_changed):
		_data_file.current_entry.current_dialogue_changed.connect(_on_dialogue_changed)


func _on_dialogue_changed() -> void:
	if not _data_file.current_entry.current_dialogue.content_changed.is_connected(
		_on_dialogue_changed
	):
		_data_file.current_entry.current_dialogue.content_changed.connect(_on_dialogue_changed)
	text = _data_file.current_entry.current_dialogue.content
	text = DialogueParser.parse(text)
