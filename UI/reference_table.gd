class_name ReferenceTable
extends FoldableContainer

@export var _data_store: DataStore

var _reference_csv: Dictionary[String, Reference] = { }

@onready var open_csv_button: Button = %"OpenCSVButton"
@onready var _notes_label: Label = %"Notes"
@onready var _notes_container: Container = %"NotesContainer"
@onready var _en_to_target_label: Label = %"EnToTarget"
@onready var _jp_to_target_label: Label = %"JpToTarget"
@onready var _open_file_dialogue: FileDialog = $"OpenFileDialog"


func _ready() -> void:
	_data_store.dialogue_selected.connect(_on_dialogue_selected)
	open_csv_button.pressed.connect(load_csv_flow)


func load_csv_flow():
	_open_file_dialogue.show()
	var file_path = await _open_file_dialogue.file_selected
	WorkerThreadPool.add_task(load_reference_csv.bind(file_path))
	folded = false


func load_reference_csv(path: String) -> Error:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return FileAccess.get_open_error()
	while not file.eof_reached():
		var data = file.get_csv_line()
		if data[0].is_empty() and data.size() == 1:
			continue
		var key = data[0]
		var notes = data[1]
		var en_to_target = data[2]
		var jp_to_target = data[3]
		_reference_csv[key] = Reference.new(notes, en_to_target, jp_to_target)
	return OK


func _on_dialogue_selected(dialogue: Dialogue):
	if _reference_csv.is_empty():
		print("empty")
		return

	var reference: Reference = _reference_csv.get(dialogue.key)
	if reference == null:
		print("not found")
		return
	if reference.notes.is_empty():
		_notes_container.hide()

	_notes_label.text = reference.notes.replace("\n", " ")
	_en_to_target_label.text = reference.en_to_target.replace("\n", " ")
	_jp_to_target_label.text = reference.jp_to_target.replace("\n", " ")


class Reference:
	var notes: String
	var en_to_target: String
	var jp_to_target: String


	func _init(
		new_notes: String,
		new_en_to_target: String,
		new_jp_to_target: String,
	) -> void:
		notes = new_notes
		en_to_target = new_en_to_target
		jp_to_target = new_jp_to_target
