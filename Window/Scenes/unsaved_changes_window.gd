extends ConfirmationDialog
class_name UnsavedChangesWindow

@export var _data_store: DataStore


func handle_destructive_action(action: Callable) -> void:
	var changes_hash = JSONHandler.stringify_data_store(_data_store).sha256_text()
	if _data_store.file_hash_sha256.is_empty():
		action.call()
	elif _data_store.file_hash_sha256 == changes_hash:
		action.call()
	else:
		UIWatcher.watch(self, confirmed, action)
		show()
