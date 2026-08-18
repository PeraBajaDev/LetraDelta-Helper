class_name Dialogue
extends Resource

signal content_changed()

@export var _key: StringName
@export var _content: String
@export var _original_content: String
@export var _last_edited_by: StringName

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


func _init(
	new_key: StringName,
	new_content: String,
	new_original_content: String,
	new_last_edited_by: String,
) -> void:
	_key = new_key
	_content = new_content
	_original_content = new_original_content
	_last_edited_by = new_last_edited_by


func _to_string() -> String:
	return "\t_key: %s\n_content: %s\n_original_content: %s\n_last_edited_by: %s" % [
		_key,
		_content,
		_original_content,
		_last_edited_by,
	]


func set_content_without_signal_emission(value: String):
	if value == null:
		return
	_content = value
