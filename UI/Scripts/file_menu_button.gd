extends MenuButton

@export var _data_store: DataStore

@onready var _open_file_dialogue: FileDialog = $OpenFileDialog
@onready var _popup: PopupMenu = get_popup()
enum ActionsIDs {
	NEW_FILE = 2,
	SAVE_FILE = 3,
	SAVE_FILE_AS = 4,
	EXPORT_TO_GAME_FORMAT,
	OPEN_RECENT_FILES,
	OPEN_FILE = 1,
}


func _ready() -> void:
	_popup.id_pressed.connect(_do_action)


func _do_action(id: int):
	match id:
		ActionsIDs.OPEN_FILE:
			_open_file()


func _open_file():
	_open_file_dialogue.show()
	var path = await _open_file_dialogue.file_selected
	WorkerThreadPool.add_task(
		func():
			var data_source_from_json := JSONHandler.get_data_store(path)
			if data_source_from_json.load_error != OK:
				push_error("Error al cargar el archivo")
				return
			_data_store.copy_from_resource(data_source_from_json)
			_close_waiting_window.call_deferred()
			_data_store.notify_data_loaded.call_deferred(),
	)
	var main_window = owner as Control
	main_window.modulate = Color.GREEN


func _close_waiting_window():
	var main_window = owner as Control
	main_window.modulate = Color.WHITE
