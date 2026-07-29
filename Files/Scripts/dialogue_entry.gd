class_name DialogueEntry

var _id: StringName

var _dialogues: Array[Dialogue]


func _init(id: StringName, dialogues: Array[Dialogue] = []) -> void:
	_id = id
	_dialogues = dialogues
