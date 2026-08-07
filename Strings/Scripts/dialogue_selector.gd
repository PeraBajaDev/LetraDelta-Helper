extends ItemList
class_name DialogueSelector

var _data_file: DataStore

var data_file: DataStore:
	get:
		return data_file
	set(value):
		if value == null:
			return
		_data_file = value
		UIWatcher.watch(self, _data_file.entry_selected, update_list)


func _ready() -> void:
	item_selected.connect(_on_item_selected)


func update_list(entry: DialogueEntry):
	clear()
	UIWatcher.watch(self, entry.current_dialogue_changed, _on_current_dialogue_changed)
	for dialogue in entry.dialogues:
		var item_text: String = dialogue.content if not dialogue.content.is_empty() else dialogue.original_content
		add_item(item_text)
		var dialogue_index: int = entry.dialogues.find(dialogue)
		UIWatcher.watch(self, dialogue.content_changed, _update_item.bind(dialogue_index))


func _update_item(dialogue: Dialogue, index: int):
	var item_text: String = dialogue.content if not dialogue.content.is_empty() else dialogue.original_content
	set_item_text(index, item_text)


func _on_current_dialogue_changed(dialogue: Dialogue):
	var index := _data_file.current_entry.dialogues.find(dialogue)
	select(index)
	ensure_current_is_visible.call_deferred()


func _on_item_selected(index: int):
	_data_file.current_entry.current_dialogue = _data_file.current_entry.dialogues[index]
