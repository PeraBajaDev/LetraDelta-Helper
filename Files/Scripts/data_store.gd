extends Resource
class_name DataStore

signal entry_selected(entry: DialogueEntry)
signal dialogue_selected(dialogue: Dialogue)
signal data_loaded
signal data_freed
@export var _style: StringName
@export var load_error: Error = Error.OK
var style: StringName:
	get:
		return _style
var _current_entry: DialogueEntry
var current_entry: DialogueEntry:
	get:
		return _current_entry

@export var _file_hash_sha256: StringName
var file_hash_sha256: StringName:
	get:
		return _file_hash_sha256


func select_entry(entry: DialogueEntry) -> void:
	if _current_entry == entry:
		return
	_current_entry = entry
	entry_selected.emit(_current_entry)


@export var _dialogues_entries: Array[DialogueEntry]
var dialogues_entries: Array[DialogueEntry]:
	get:
		return _dialogues_entries

@export var _path: StringName
var path: StringName:
	get:
		return _path


func _init(
	new_style: StringName = "",
	new_dialogues_entries: Array[DialogueEntry] = [],
	new_path: StringName = "",
	new_file_hash_sha256: StringName = "",
) -> void:
	_style = new_style
	_dialogues_entries = new_dialogues_entries
	_path = new_path
	_file_hash_sha256 = new_file_hash_sha256


func notify_data_loaded():
	data_loaded.emit()


func notify_dialogue_changed(dialogue: Dialogue) -> void:
	dialogue_selected.emit(dialogue)


func notify_data_freed():
	data_freed.emit()


func save_new_hash(value: StringName):
	if value.is_empty():
		return
	_file_hash_sha256 = value


func _to_string() -> String:
	return "Style: %s \n dialogue_entries: %s" % [_style, _dialogues_entries]


static func create_with_given_error(error: Error):
	var data_store = DataStore.new()
	data_store.load_error = error
	return data_store
