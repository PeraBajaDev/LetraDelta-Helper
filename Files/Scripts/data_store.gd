class_name DataStore
extends Resource

signal entry_selected(entry: DialogueEntry)
signal dialogue_selected(dialogue: Dialogue)
signal entries_filtered(entries: Array[DialogueEntry], state: Dialogue.State)
signal data_loaded
signal data_freed

@export var load_error: Error = Error.OK
@export var _style: StringName

@export var _file_hash_sha256: StringName

@export var _dialogues_entries: Array[DialogueEntry]

@export var _path: StringName

var style: StringName:
	get:
		return _style
var current_entry: DialogueEntry:
	get:
		return _current_entry
var file_hash_sha256: StringName:
	get:
		return _file_hash_sha256
var dialogues_entries: Array[DialogueEntry]:
	get:
		return _dialogues_entries
var path: StringName:
	get:
		return _path
var _current_entry: DialogueEntry


static func create_with_given_error(error: Error):
	var data_store = DataStore.new()
	data_store.load_error = error
	return data_store


func _init(
	new_style: StringName = "",
	new_dialogues_entries: Array[DialogueEntry] = [],
	new_path: StringName = "",
	new_file_hash_sha256: StringName = "",
) -> void:
	_style = new_style
	_dialogues_entries = new_dialogues_entries
	_path = new_path.trim_suffix(".tmp")
	_file_hash_sha256 = new_file_hash_sha256


func _to_string() -> String:
	return "Style: %s \n dialogue_entries: %s" % [_style, _dialogues_entries]


func select_entry(entry: DialogueEntry) -> void:
	if _current_entry == entry:
		return
	_current_entry = entry
	entry_selected.emit(_current_entry)


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


## Emits entries_filtered signal with the state provided
func filter_entries_by_state(state: Dialogue.State) -> void:
	var by_state = func(entry: DialogueEntry):
		return entry.get_state() == state
	entries_filtered.emit(_dialogues_entries.filter(by_state), state)


## Copies the data from the data_store into this data_store. Removes tmp file in the process.
func replace_data(resource: DataStore) -> int:
	if path:
		DirAccess.remove_absolute(path + ".tmp")
	return copy_from_resource(resource)
