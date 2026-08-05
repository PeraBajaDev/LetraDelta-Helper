extends RefCounted
class_name Dialogue

var _key: StringName
var _content: String
var _original_content: String
var _last_edited_by: StringName

signal content_changed()

var key: String:
	get:
		return _key

var content: String:
	get:
		return _content
	set(value):
		if value == null:
			return
		_content = value
		content_changed.emit()

var original_content: String:
	get:
		return _original_content


func _init(
	new_key: StringName,
	new_content: String,
	new_original_content: String,
	last_edited_by: String,
) -> void:
	_key = new_key
	_content = new_content
	_original_content = new_original_content
	_last_edited_by = last_edited_by


func _to_string() -> String:
	return "\t_key: %s\n_content: %s\n_original_content: %s\n_last_edited_by: %s" % [
		_key,
		_content,
		_original_content,
		_last_edited_by,
	]
