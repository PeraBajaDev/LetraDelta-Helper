class_name DialogueStateResult

var state: Dialogue.State:
	get:
		return _state

var context: Array:
	get:
		return _context

var _state: Dialogue.State
var _context: Array


func _init(new_state: Dialogue.State, new_context: Array = []) -> void:
	_state = new_state
	_context = new_context
