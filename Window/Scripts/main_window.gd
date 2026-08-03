extends Control

var data_file: DataFile
@onready var entry_list: EntryList = %EntryList
@onready var dialogue_selector: DialogueSelector = %DialogueSelector
@onready var original_dialogue: OriginalDialogue = %OriginalDialogue
@onready var dialogue_edit: DialogueEdit = %DialogueEdit
@onready var dialogue_label: DialogueLabel = %DialogueLabel


func _ready() -> void:
	var full_path: String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS).path_join(
		r"PeraBajaDev/scripts varios/nuevo_archivo.json"
	)
	data_file = JSONHandler.get_data_file(full_path)
	if data_file == null:
		print("Error al cargar el archivo")
		return
	entry_list.data_file = data_file
	dialogue_selector.data_file = data_file
	original_dialogue.data_file = data_file
	dialogue_edit.data_file = data_file
	dialogue_label.data_file = data_file
