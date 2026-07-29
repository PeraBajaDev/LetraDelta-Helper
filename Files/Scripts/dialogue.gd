extends RefCounted
class_name Dialogue

var _key: StringName
var _content: String
var _original_content: String
var _last_edited_by: StringName


func _init(key: StringName, content: String, original_content: String, last_edited_by) -> void:
	_key = key
	_content = content
	_original_content = original_content
	_last_edited_by = last_edited_by
