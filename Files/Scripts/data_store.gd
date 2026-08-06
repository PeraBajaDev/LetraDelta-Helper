extends Resource
class_name DataStore

signal current_entry_changed()
var _style: StringName

var style: StringName:
	get:
		return _style
var _current_entry: DialogueEntry
var current_entry: DialogueEntry:
	get:
		return _current_entry
	set(value):
		if value == null:
			return
		_current_entry = value
		current_entry_changed.emit()

var _dialogues_entries: Array[DialogueEntry]
var dialogues_entries: Array[DialogueEntry]:
	get:
		return _dialogues_entries


func _init(new_style: StringName, new_dialogues_entries: Array[DialogueEntry] = []) -> void:
	_style = new_style
	_dialogues_entries = new_dialogues_entries


func _to_string() -> String:
	return "Style: %s \n dialogue_entries: %s" % [_style, _dialogues_entries]
