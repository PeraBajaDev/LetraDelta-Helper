extends ItemList
class_name DialogueSelector

@export var _data_store: DataStore


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	_data_store.data_loaded.connect(_on_data_loaded)


func _on_data_loaded():
	UIWatcher.watch(self, _data_store.entry_selected, update_list)


func update_list(entry: DialogueEntry):
	clear()
	UIWatcher.watch(self, entry.current_dialogue_changed, _on_current_dialogue_changed)
	for dialogue in entry.dialogues:
		var item_text: String = dialogue.content if not dialogue.content.is_empty() else dialogue.original_content
		add_item(item_text)
		var dialogue_index: int = entry.dialogues.find(dialogue)
		UIWatcher.watch(self, dialogue.content_changed, _update_item.bind(dialogue, dialogue_index))


func _update_item(dialogue: Dialogue, index: int):
	var item_text: String = dialogue.content if not dialogue.content.is_empty() else dialogue.original_content
	set_item_text(index, item_text)


func _on_current_dialogue_changed(dialogue: Dialogue):
	var index := _data_store.current_entry.dialogues.find(dialogue)
	select(index)
	ensure_current_is_visible.call_deferred()


func _on_item_selected(index: int):
	_data_store.current_entry.current_dialogue = _data_store.current_entry.dialogues[index]
	_data_store.notify_dialogue_changed(_data_store.current_entry.current_dialogue)
