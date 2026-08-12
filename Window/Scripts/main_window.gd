extends Control

@export var _data_store: DataStore


func _ready() -> void:
	_data_store.data_loaded.connect(_on_data_loaded)


func _on_data_loaded():
	get_window().title = _data_store.path.get_file()
