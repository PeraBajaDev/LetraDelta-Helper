extends ItemList
class_name EntryList

var _data_file: DataStore
var data_file: DataStore:
	set(value):
		if value != null:
			_data_file = value
		if not _data_file.entry_selected.is_connected(_on_current_entry_changed):
			_data_file.entry_selected.connect(_on_current_entry_changed)
		clear()
		for entry in _data_file.dialogues_entries:
			add_item(entry.id)


func _ready() -> void:
	item_selected.connect(_on_item_selected)


func _on_current_entry_changed(entry: DialogueEntry):
	var index = _data_file.dialogues_entries.find(entry)
	select(index)
	center_on_current()


func _on_item_selected(index: int):
	var selected_entry := _data_file.dialogues_entries[index]
	_data_file.select_entry(selected_entry)
