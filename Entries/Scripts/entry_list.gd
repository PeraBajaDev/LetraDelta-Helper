extends ItemList
class_name EntryList

@export var _data_store: DataStore


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	_data_store.data_loaded.connect(_on_data_loaded)


func _on_data_loaded():
	clear()
	UIWatcher.watch(self, _data_store.entry_selected, _on_current_entry_changed)
	for entry in _data_store.dialogues_entries:
		add_item(entry.id)


func _on_current_entry_changed(entry: DialogueEntry):
	var index = _data_store.dialogues_entries.find(entry)
	select(index)
	center_on_current()


func _on_item_selected(index: int):
	var selected_entry := _data_store.dialogues_entries[index]
	_data_store.select_entry(selected_entry)
