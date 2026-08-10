extends MenuButton
class_name FileMenuButton
@export var _data_store: DataStore

@onready var _open_file_dialogue: FileDialog = $OpenFileDialog
@onready var _popup: PopupMenu = get_popup()
const RECENT_FILES_SUBMENU: PackedScene = preload("uid://b57arje145ojq")
enum ActionsIDs {
	NEW_FILE = 2,
	SAVE_FILE = 3,
	SAVE_FILE_AS = 4,
	EXPORT_TO_GAME_FORMAT,
	OPEN_RECENT_FILES = 11,
	OPEN_FILE = 1,
}


func _ready() -> void:
	_popup.id_pressed.connect(_do_action)
	var item_index = _popup.get_item_index(ActionsIDs.OPEN_RECENT_FILES)
	var recent_files_submenu = RECENT_FILES_SUBMENU.instantiate()
	_popup.set_item_submenu_node(item_index, recent_files_submenu)


func _do_action(id: int):
	match id:
		ActionsIDs.OPEN_FILE:
			_open_file()


func _open_file():
	_open_file_dialogue.show()
	var path = await _open_file_dialogue.file_selected
	WorkerThreadPool.add_task(create_data_store.bind(path))

	var main_window = owner as Control
	main_window.modulate = Color.GREEN


func _close_waiting_window() -> void:
	var main_window = owner as Control
	main_window.modulate = Color.WHITE


func create_data_store(path: StringName):
	var data_source_from_json := JSONHandler.get_data_store(path)
	if data_source_from_json.load_error != OK:
		push_error("Error al cargar el archivo")
		return
	RecentFilesHandler.add_to_recent_files(path)
	_data_store.copy_from_resource(data_source_from_json)
	# Calling
	_close_waiting_window.call_deferred()
	_data_store.notify_data_loaded.call_deferred()
