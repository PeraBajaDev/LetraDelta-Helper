class_name Dialogue
extends Resource

signal content_changed()
signal needs_review_changed(dialogue: Dialogue)

enum State {
	INVALID_TAGS,
	INVALID_SIGNS,
	OUT_OF_THE_BOX,
	NEEDS_REVIEW,
	GRAMMAR_ERROR,
	TRANSLATED,
	NOT_TRANSLATED,
}

@export var _key: StringName
@export var _content: String
@export var _original_content: String
@export var _last_edited_by: StringName
@export var _needs_review: bool

var key: String:
	get:
		return _key

var content: String:
	get:
		return _content
	set(value):
		if value == null or _content == value:
			return
		_content = value
		content_changed.emit()

var original_content: String:
	get:
		return _original_content

var last_edited_by:
	get:
		return _last_edited_by

var needs_review: bool:
	get:
		return _needs_review

var _validators: Array[Callable] = [
	_check_invalid_tags,
	_check_invalid_signs,
	_check_out_of_the_box,
	_check_needs_review,
	_check_grammar_error,
	_check_translated,
]


func _init(
	new_key: StringName,
	new_content: String,
	new_original_content: String,
	new_last_edited_by: String,
	new_needs_review: bool,
) -> void:
	_key = new_key
	_content = new_content
	_original_content = new_original_content
	_last_edited_by = new_last_edited_by
	_needs_review = new_needs_review


func _to_string() -> String:
	return "\t_key: %s\n_content: %s\n_original_content: %s\n_last_edited_by: %s" % [
		_key,
		_content,
		_original_content,
		_last_edited_by,
	]


func mark_for_review(value: bool = true):
	if value == null:
		return
	_needs_review = value
	needs_review_changed.emit(self)


func set_content_without_signal_emission(value: String):
	if value == null:
		return
	_content = value


func get_state_report() -> DialogueStateResult:
	for validator: Callable in _validators:
		var result: DialogueStateResult = validator.call()
		if result != null:
			return result

	return null


# --- Funciones de Validación con Feedback ---
func _check_invalid_tags() -> DialogueStateResult:
	var missing_tags: Array = []
	var extra_tags: Array = []

	if not missing_tags.is_empty() or not extra_tags.is_empty():
		var details = [missing_tags, extra_tags]
		return DialogueStateResult.new(
			State.INVALID_TAGS,
			details,
		)
	return null


func _check_invalid_signs() -> DialogueStateResult:
	var missing_signs: Array = []
	if not _has_closed_signs(_content, "¿", "?"):
		missing_signs.append("¿?")
	if not _has_closed_signs(_content, "¡", "!"):
		missing_signs.append("¡!")
	if not _has_closed_signs(_content, "(", ")"):
		missing_signs.append("()")
	if not missing_signs.is_empty():
		return DialogueStateResult.new(
			State.INVALID_SIGNS,
			missing_signs,
		)
	return null


func _has_closed_signs(text: String, char_opening: String, char_ending) -> bool:
	var stack := []
	for character in text:
		if character == char_opening:
			stack.push_back(char_opening)
		elif character == char_ending:
			var element = stack.pop_back()
			if element == null:
				return false

	return stack.is_empty()


func _check_out_of_the_box() -> DialogueStateResult:
	#TODO
	var overflows: bool = false
	if overflows:
		return DialogueStateResult.new(
			State.OUT_OF_THE_BOX,
		)
	return null


func _check_needs_review() -> DialogueStateResult:
	if needs_review:
		return DialogueStateResult.new(State.NEEDS_REVIEW)
	return null


func _check_grammar_error() -> DialogueStateResult:
	#TODO
	var grammar_error_details := []
	if not grammar_error_details.is_empty():
		return DialogueStateResult.new(
			State.GRAMMAR_ERROR,
			grammar_error_details,
		)
	return null


func _check_translated() -> DialogueStateResult:
	if not content.is_empty():
		return DialogueStateResult.new(State.TRANSLATED)
	else:
		return DialogueStateResult.new(State.NOT_TRANSLATED)
