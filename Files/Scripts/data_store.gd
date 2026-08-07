extends Resource
class_name DataStore

signal entry_selected(entry: DialogueEntry)
signal dialogue_selected(dialogue: Dialogue)
signal data_loaded
@export var _style: StringName
var style: StringName:
	get:
		return _style
var _current_entry: DialogueEntry
var current_entry: DialogueEntry:
	get:
		return _current_entry


func select_entry(entry: DialogueEntry) -> void:
	if _current_entry == entry:
		return
	_current_entry = entry
	entry_selected.emit(_current_entry)


@export var _dialogues_entries: Array[DialogueEntry]
var dialogues_entries: Array[DialogueEntry]:
	get:
		return _dialogues_entries


func _init(new_style: StringName = "", new_dialogues_entries: Array[DialogueEntry] = []) -> void:
	_style = new_style
	_dialogues_entries = new_dialogues_entries


func notify_data_loaded():
	data_loaded.emit()


func notify_dialogue_changed(dialogue: Dialogue) -> void:
	dialogue_selected.emit(dialogue)


func _to_string() -> String:
	return "Style: %s \n dialogue_entries: %s" % [_style, _dialogues_entries]
