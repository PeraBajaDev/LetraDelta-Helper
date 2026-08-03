extends TextEdit
class_name DialogueEdit
var _data_file: DataFile
var data_file: DataFile:
	get:
		return data_file
	set(value):
		if value == null:
			return
		_data_file = value
		_data_file.current_entry_changed.connect(_on_current_entry_changed)


func _ready() -> void:
	text_changed.connect(_on_text_changed)


func _on_current_entry_changed() -> void:
	if _data_file.current_entry == null or _data_file.current_entry.current_dialogue == null:
		text = ""
		editable = false

	_data_file.current_entry.current_dialogue_changed.connect(_on_dialogue_changed)


func _on_dialogue_changed() -> void:
	var current_dialogue := _data_file.current_entry.current_dialogue
	if current_dialogue == null:
		return
	editable = true
	var caret_column := get_caret_column()
	var caret_line := get_caret_line()
	text = current_dialogue.content
	set_caret_column(caret_column)
	set_caret_line(caret_line)


func _on_text_changed() -> void:
	var current_dialogue := _data_file.current_entry.current_dialogue
	current_dialogue.content = text
