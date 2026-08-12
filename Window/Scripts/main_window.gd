extends Control

@export var _data_store: DataStore


func _ready() -> void:
	_data_store.data_loaded.connect(_on_data_loaded)
	_data_store.data_freed.connect(_on_data_freed)


func _on_data_loaded():
	get_window().title = _data_store.path.get_file()


func _on_data_freed():
	get_window().title = "LetraDelta Helper"
