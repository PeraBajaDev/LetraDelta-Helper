extends RefCounted
class_name DataFile

var _style: StringName

var style: StringName:
	get:
		return _style

var _dialogues_entries: Array[DialogueEntry]


func _init(new_style: StringName, dialogues_entries: Array[DialogueEntry] = []) -> void:
	_style = new_style
	_dialogues_entries = dialogues_entries
