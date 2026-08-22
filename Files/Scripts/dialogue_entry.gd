class_name DialogueEntry
extends Resource

signal current_dialogue_changed(dialogue: Dialogue)

@export var _id: StringName

@export var _dialogues: Array[Dialogue]

var current_dialogue: Dialogue:
	get:
		return _current_dialogue
	set(value):
		if value == null or value == _current_dialogue:
			return
		_current_dialogue = value
		current_dialogue_changed.emit(value)

var id: StringName:
	get:
		return _id

var dialogues: Array[Dialogue]:
	get:
		return _dialogues
var _current_dialogue: Dialogue


func _init(new_id: StringName, new_dialogues: Array[Dialogue] = []) -> void:
	_id = new_id
	_dialogues = new_dialogues


func _to_string() -> String:
	return "ID: %s\n dialogues: %s" % [_id, _dialogues]


func needs_any_review() -> bool:
	return _dialogues.any(
		func(d: Dialogue):
			return d.needs_review,
	)


func set_current_dialogue_by_key(_key: String):
	pass


func get_state() -> Dialogue.State:
	var has_dialogue_with_state = func(dialogue: Dialogue, state: Dialogue.State):
		return dialogue.get_state_report().state == state
	for i in range(Dialogue.State.keys().size()):
		var state := i as Dialogue.State
		if state == Dialogue.State.TRANSLATED:
			if dialogues.all(has_dialogue_with_state.bind(state)):
				return state
			else:
				continue
		if dialogues.any(has_dialogue_with_state.bind(state)):
			return state
	return Dialogue.State.NOT_TRANSLATED
