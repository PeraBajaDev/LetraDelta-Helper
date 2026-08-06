extends Resource
class_name DialogueEntry

signal current_dialogue_changed()
var _id: StringName

var _dialogues: Array[Dialogue]

var _current_dialogue: Dialogue

var current_dialogue: Dialogue:
	get:
		return _current_dialogue
	set(value):
		if value == null or value == _current_dialogue:
			return
		_current_dialogue = value
		current_dialogue_changed.emit()

var id: StringName:
	get:
		return _id

var dialogues: Array[Dialogue]:
	get:
		return _dialogues


func _init(new_id: StringName, new_dialogues: Array[Dialogue] = []) -> void:
	_id = new_id
	_dialogues = new_dialogues


func _to_string() -> String:
	return "ID: %s\n dialogues: %s" % [_id, _dialogues]
