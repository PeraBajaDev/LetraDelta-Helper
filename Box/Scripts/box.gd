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
		_data_file.current_entry_changed.connect(_on_current_entry_changed)


func _on_current_entry_changed() -> void:
	if _data_file.current_entry == null or _data_file.current_entry.current_dialogue == null:
		text = ""

	_data_file.current_entry.current_dialogue_changed.connect(_on_dialogue_changed)


func _on_dialogue_changed() -> void:
	text = _data_file.current_entry.current_dialogue.content
	text = DialogueParser.parse(text)
