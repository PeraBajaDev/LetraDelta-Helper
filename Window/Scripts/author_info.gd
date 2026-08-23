class_name AuthorInfo
extends ConfirmationDialog

@onready var name_edit: LineEdit = $"Label/LineEdit"


static func get_user_name() -> String:
	var value = FileAccess.get_file_as_string("user://username.dat")
	return value if value else OS.get_environment("USERNAME")


func _ready() -> void:
	visibility_changed.connect(
		func():
			name_edit.placeholder_text = get_user_name(),
	)
	name_edit.placeholder_text = get_user_name()
	confirmed.connect(_on_confirmed)


func _on_confirmed():
	var file = FileAccess.open("user://username.dat", FileAccess.WRITE)
	file.store_string(name_edit.text)
