extends TextEdit
class_name DialogueEdit
var _data_file: DataFile
@onready var _replace_similar_entries_check: CheckBox = $ReplaceSimilar
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
	if not _data_file.current_entry.current_dialogue_changed.is_connected(_on_dialogue_changed):
		_data_file.current_entry.current_dialogue_changed.connect(_on_dialogue_changed)


func _on_dialogue_changed() -> void:
	var current_dialogue := _data_file.current_entry.current_dialogue
	if current_dialogue == null:
		return
	editable = true
	var caret_column := get_caret_column()
	var caret_line := get_caret_line()
	text = current_dialogue.content
	set_caret_line(caret_line)
	set_caret_column(caret_column)


func _on_text_changed() -> void:
	print("texto cambiado")
	var current_dialogue := _data_file.current_entry.current_dialogue
	if _replace_similar_entries_check.button_pressed:
		current_dialogue.content = text
		_replace_similar_entries()
	else:
		current_dialogue.content = text


func _replace_similar_entries():
	var current_dialogue := _data_file.current_entry.current_dialogue
	var all_dialogues: Array[Dialogue] = []
	for entry in _data_file.dialogues_entries:
		all_dialogues.append_array(entry.dialogues)
	for dialogue in all_dialogues:
		if current_dialogue.original_content == dialogue.original_content:
			dialogue.set_content_without_signal_emission(text)
