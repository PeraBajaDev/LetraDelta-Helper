extends Timer

@export var _data_store: DataStore


func _ready() -> void:
	_data_store.data_loaded.connect(_on_data_loaded)


func _on_data_loaded():
	UIWatcher.watch(self, timeout, _save_tmp)


func _save_tmp():
	var error: Error = JSONHandler.write_data_store_tmp_file(_data_store)
	if error:
		push_error(error_string(error))
	else:
		print("Guardado backup")
