extends Control

@export var _data_store: DataStore
@onready var _unsaved_changes_window: UnsavedChangesWindow = %UnsavedChangesWindow


func _ready() -> void:
	_data_store.data_loaded.connect(_on_data_loaded)
	_data_store.data_freed.connect(_on_data_freed)
	var tree = get_tree()
	tree.auto_accept_quit = false
	tree.root.close_requested.connect(_unsaved_changes_window.handle_destructive_action.bind(
			tree.quit
		))


func _on_data_loaded():
	get_window().title = _data_store.path.get_file()


func _on_data_freed():
	get_window().title = "LetraDelta Helper"
