extends PopupMenu

const RECENT_FILES_PATH := &"user://recent_files.dat"
const CLEAR_LIST_ID = 0

@onready var file_menu_button: FileMenuButton = $"../.."


func _ready() -> void:
	about_to_popup.connect(_on_submenu_showed)
	index_pressed.connect(_on_item_selected)


func _on_submenu_showed():
	clear()
	var recents_file_paths: PackedStringArray = FileAccess \
			.get_file_as_string(RECENT_FILES_PATH) \
			.strip_edges(false).split("\n")
	for i in range(len(recents_file_paths)):
		if not recents_file_paths[i].is_absolute_path():
			continue
		add_item(recents_file_paths[i].get_file(), i + 2)
		var item_index = get_item_index(i + 2)
		set_item_tooltip(item_index, recents_file_paths[i])
		set_item_metadata(item_index, recents_file_paths[i])

	#For visual porpuses
	add_separator("", 100)
	add_item("Clear list", 0)
	pass


func _on_item_selected(index: int):
	if get_item_id(index) == CLEAR_LIST_ID:
		RecentFilesHandler.erase_recent_files()
		return
	var recent_file_path = get_item_metadata(index)
	WorkerThreadPool.add_task(file_menu_button.create_data_store.bind(recent_file_path))
	file_menu_button.loading_window.show()
