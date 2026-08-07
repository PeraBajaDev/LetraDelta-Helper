extends Control

@export var _data_store: DataStore


func _ready() -> void:
	var full_path: String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS).path_join(
		r"PeraBajaDev/scripts varios/nuevo_archivo.json"
	)
	print("antes", _data_store.get_instance_id(), "contenido: ", _data_store.style)
	var data_source_from_json := JSONHandler.get_data_store(full_path)
	var error = _data_store.copy_from_resource(data_source_from_json)
	print(
		"data de get_data_store",
		data_source_from_json.get_instance_id(),
		" contenido:",
		data_source_from_json.style,
	)
	print(
		"después",
		_data_store.get_instance_id(),
		" contenido:",
		_data_store.style,
		" error: ",
		error_string(error),
	)
	if _data_store == null:
		push_error("Error al cargar el archivo")
		return
	_data_store.notify_data_loaded.call_deferred()
