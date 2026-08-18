class_name DialogueSelector
extends ItemList

@export var _data_store: DataStore
@export var _state_icons: Dictionary[Dialogue.State, Texture2D]


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	_data_store.data_loaded.connect(_on_data_loaded)
	_data_store.data_freed.connect(clear)


func update_list(entry: DialogueEntry):
	clear()
	UIWatcher.watch(self, _data_store.dialogue_selected, _on_current_dialogue_changed)
	for dialogue in entry.dialogues:
		var item_text: String = dialogue.content if not dialogue.content.is_empty() else dialogue.original_content
		var item_index: int = add_item(item_text)
		set_item_metadata(item_index, dialogue)
		_set_item_icon_with_state(dialogue, item_index)
		UIWatcher.watch(self, dialogue.content_changed, _update_item.bind(dialogue))
		UIWatcher.watch(
			self,
			dialogue.needs_review_changed,
			_set_item_icon_with_state.bind(item_index),
		)


func _on_data_loaded():
	UIWatcher.watch(self, _data_store.entry_selected, update_list)


func _set_item_icon_with_state(dialogue: Dialogue, index: int):
	var dialogue_state: DialogueStateResult = dialogue.get_state_report()
	set_item_icon(index, _state_icons[dialogue_state.state])


func _update_item(dialogue: Dialogue):
	var index: int = _get_item_index_with_dialogue(dialogue)
	if index <= -1:
		return
	var item_text: String = dialogue.content if not dialogue.content.is_empty() else dialogue.original_content
	_set_item_icon_with_state(dialogue, index)
	set_item_text(index, item_text)


func _on_current_dialogue_changed(dialogue: Dialogue):
	select(_get_item_index_with_dialogue(dialogue))
	ensure_current_is_visible.call_deferred()


func _get_item_index_with_dialogue(dialogue: Dialogue) -> int:
	for i in range(item_count):
		if get_item_metadata(i) == dialogue:
			return i
	return -1


func _on_item_selected(index: int):
	var dialogue: Dialogue = get_item_metadata(index)
	_data_store.current_entry.current_dialogue = dialogue
	_data_store.notify_dialogue_changed(dialogue)
