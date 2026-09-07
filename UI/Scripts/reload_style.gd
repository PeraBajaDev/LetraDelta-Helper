extends Button

@export var _data_store: DataStore

@onready var _error_message: AcceptDialog = %"ErrorDialogWindow"


func _ready() -> void:
	_data_store.data_loaded.connect(
		func():
			disabled = false,
	)
	_data_store.data_freed.connect(
		func():
			disabled = true,
	)
	pressed.connect(_on_pressed)


func _on_pressed():
	const STYLES_DIR_PATH = "user://Styles"
	var style_dir = DirAccess.open(STYLES_DIR_PATH)
	if style_dir == null:
		DirAccess.make_dir_absolute(STYLES_DIR_PATH)
	var message_context = {
		"style_folder": _data_store.style,
		"dir": style_dir.get_current_dir(),
	}
	if not style_dir.dir_exists(_data_store.style):
		_error_message.dialog_text = tr("STYLE_FOLDER_NOT_FOUND").format(message_context)
		_error_message.show()
		return

	style_dir.change_dir(_data_store.style)

	if style_dir.get_directories().size() == 0:
		_error_message.dialog_text = tr("STYLE_FOLDER_EMPTY")
		_error_message.show()
		return
	const CONTENT_DIR_PATHS := ["Boxes", "Portraits"]
	for dir_path in CONTENT_DIR_PATHS:
		if not style_dir.dir_exists(dir_path):
			_error_message.dialog_text = tr("STYLE_FOLDER_MISSING_CONTENT").format(
				message_context.merged({ "missing_folder": dir_path })
			)
			_error_message.show()
			return
