extends MenuButton
class_name FileMenuButton
@export var _data_store: DataStore

@onready var _open_file_dialogue: FileDialog = $OpenFileDialog
@onready var _save_file_dialogue: FileDialog = $SaveFileDialog
@onready var _popup: PopupMenu = get_popup()
@onready var error_window: AcceptDialog = %ErrorDialogWindow
@onready var loading_window: Window = %LoadingWindow
const RECENT_FILES_SUBMENU: PackedScene = preload("uid://b57arje145ojq")
enum ActionsIDs {
	NEW_FILE = 2,
	SAVE_FILE = 3,
	SAVE_FILE_AS = 8,
	EXPORT_TO_GAME_FORMAT = 12,
	OPEN_RECENT_FILES = 11,
	OPEN_FILE = 1,
	CLOSE_FILE = 7,
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
		ActionsIDs.SAVE_FILE_AS:
			_save_file_as()
		ActionsIDs.SAVE_FILE:
			_save_file()
		ActionsIDs.EXPORT_TO_GAME_FORMAT:
			_export_to_game_format()
		ActionsIDs.CLOSE_FILE:
			print("cerrando")
			_data_store.copy_from_resource(DataStore.new())
			_data_store.notify_data_loaded()


func _open_file():
	_open_file_dialogue.show()
	var path = await _open_file_dialogue.file_selected
	WorkerThreadPool.add_task(create_data_store.bind(path))
	loading_window.show()


func _save_file():
	WorkerThreadPool.add_task(
		func():
			var error := JSONHandler.save_data_store(_data_store)
			if error:
				show_error.call_deferred(error, _data_store.path),
	)
	loading_window.show()


func _save_file_as():
	_save_file_dialogue.show()
	var save_as_path = await _save_file_dialogue.file_selected
	WorkerThreadPool.add_task(
		func():
			var error := JSONHandler.save_data_store(_data_store, save_as_path)
			if error:
				show_error.call_deferred(error, save_as_path),
	)
	loading_window.show()


func _close_waiting_window() -> void:
	loading_window.hide()


func create_data_store(path: StringName):
	var data_source_from_json := JSONHandler.get_data_store(path)
	if data_source_from_json.load_error != OK:
		show_error.call_deferred(data_source_from_json.load_error, path)
		return
	RecentFilesHandler.add_to_recent_files(path)
	_data_store.copy_from_resource(data_source_from_json)
	# Calling
	_close_waiting_window.call_deferred()
	_data_store.notify_data_loaded.call_deferred()


func show_error(error: Error, path):
	error_window.dialog_text = tr("DATA_STORE_FILE_ERROR%d" % int(error)).format(
		{ "file_path": path, "dir": path.get_base_dir() }
	)
	error_window.show()


func _export_to_game_format():
	_save_file_dialogue.show()
	var save_as_path = await _save_file_dialogue.file_selected
	WorkerThreadPool.add_task(
		func():
			var error = JSONHandler.export_to_game_format(_data_store, save_as_path)
			if error:
				show_error.call_deferred(error, save_as_path)
			_close_waiting_window.call_deferred(),
	)
	loading_window.show()
