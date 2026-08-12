extends ItemList
class_name EntryList

@export var _data_store: DataStore


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	_data_store.data_loaded.connect(_on_data_loaded)
	_data_store.data_freed.connect(clear)


func _on_data_loaded():
	clear()
	UIWatcher.watch(self, _data_store.entry_selected, _on_current_entry_changed)
	for entry in _data_store.dialogues_entries:
		var item_index = add_item(entry.id)
		set_item_metadata(item_index, entry)


func _on_current_entry_changed(entry: DialogueEntry):
	select(_get_item_index_with_entry(entry))
	center_on_current()


func _get_item_index_with_entry(entry: DialogueEntry) -> int:
	for i in range(item_count):
		if get_item_metadata(i) == entry:
			return i
	return -1


func _on_item_selected(index: int):
	var selected_entry: DialogueEntry = get_item_metadata(index)
	_data_store.select_entry(selected_entry)
