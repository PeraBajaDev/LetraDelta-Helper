extends ItemList
class_name SimilarEntriesList
@export var _data_store: DataStore


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	_data_store.data_loaded.connect(_on_data_loaded)


func _on_data_loaded():
	UIWatcher.watch(self, _data_store.dialogue_selected, _on_current_dialogue_changed)


func _on_current_dialogue_changed(selected_dialogue: Dialogue):
	clear()
	for entry in _data_store.dialogues_entries:
		for dialogue: Dialogue in entry.dialogues:
			if dialogue.key == selected_dialogue.key:
				continue
			if dialogue.original_content == selected_dialogue.original_content:
				var item_index: int = add_item(dialogue.key)
				set_item_metadata(item_index, dialogue)


func _on_item_selected(index: int):
	var dialogue: Dialogue = get_item_metadata(index)
	for entry in _data_store.dialogues_entries:
		if entry.id in dialogue.key:
			_data_store.select_entry(entry)
			entry.current_dialogue = dialogue
			_data_store.notify_dialogue_changed(dialogue)
