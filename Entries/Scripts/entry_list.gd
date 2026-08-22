class_name EntryList
extends ItemList

@export var _data_store: DataStore
@export var _state_icons: Dictionary[Dialogue.State, Texture2D]


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	_data_store.data_loaded.connect(_on_data_loaded)
	_data_store.data_freed.connect(clear)
	_data_store.entries_filtered.connect(_on_entries_filtered)


func _on_data_loaded():
	clear()
	UIWatcher.watch(self, _data_store.entry_selected, _on_current_entry_changed)
	for entry in _data_store.dialogues_entries:
		var item_index = add_item(entry.id)
		var state := entry.get_state()
		set_item_icon(item_index, _state_icons[state])
		set_item_metadata(item_index, entry)
		for dialogue in entry.dialogues:
			dialogue.content_changed.connect(_on_dialogue_content_changed.bind(dialogue, entry))
			dialogue.needs_review_changed.connect(_on_dialogue_content_changed.bind(entry))


func _on_entries_filtered(entries: Array[DialogueEntry], state: Dialogue.State):
	clear()
	UIWatcher.watch(self, _data_store.entry_selected, _on_current_entry_changed)
	for entry in entries:
		var item_index = add_item(entry.id)
		set_item_icon(item_index, _state_icons[state])
		set_item_metadata(item_index, entry)
		for dialogue in entry.dialogues:
			UIWatcher.watch(
				self,
				dialogue.content_changed,
				_on_dialogue_content_changed.bind(dialogue, entry),
			)
			UIWatcher.watch(
				self,
				dialogue.needs_review_changed,
				_on_dialogue_content_changed.bind(entry),
			)


func _on_dialogue_content_changed(_dialogue: Dialogue, entry: DialogueEntry):
	var state := entry.get_state()
	set_item_icon(_get_item_index_with_entry(entry), _state_icons[state])


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
