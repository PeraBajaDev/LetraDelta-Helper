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
		_data_file.current_entry_changed.connect(update_list)


func _ready() -> void:
	item_selected.connect(_on_item_selected)


func update_list():
	clear()
	var current_entry: DialogueEntry = _data_file.current_entry
	if not current_entry.current_dialogue_changed.is_connected(_on_current_dialogue_changed):
		current_entry.current_dialogue_changed.connect(_on_current_dialogue_changed)
	for dialogue in current_entry.dialogues:
		var item_text: String = dialogue.content if not dialogue.content.is_empty() else dialogue.original_content
		add_item(item_text)
		var dialogue_index: int = current_entry.dialogues.find(dialogue)
		if not dialogue.content_changed.is_connected(_update_item):
			dialogue.content_changed.connect(_update_item.bind(dialogue_index))


func _update_item(index: int):
	var current_entry: DialogueEntry = _data_file.current_entry
	var dialogue := current_entry.dialogues[index]
	var item_text: String = dialogue.content if not dialogue.content.is_empty() else dialogue.original_content
	set_item_text(index, item_text)


func _on_current_dialogue_changed():
	var index := _data_file.current_entry.dialogues.find(_data_file.current_entry.current_dialogue)
	select(index)
	ensure_current_is_visible.call_deferred()


func _on_item_selected(index: int):
	_data_file.current_entry.current_dialogue = _data_file.current_entry.dialogues[index]
