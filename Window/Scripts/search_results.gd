class_name SearchResultsWindow
extends PopupMenu

@export var _data_store: DataStore


func _ready() -> void:
	index_pressed.connect(_select_dialogue)


func show_results(dialogues: Array[Dialogue]):
	show()
	clear()
	for i in range(len(dialogues)):
		add_item(dialogues[i].content, i)
		var item_index = get_item_index(i)
		set_item_metadata(item_index, dialogues[i])


func _select_dialogue(index: int):
	var dialogue: Dialogue = get_item_metadata(index)
	for entry in _data_store.dialogues_entries:
		if entry.dialogues.has(dialogue):
			_data_store.select_entry(entry)
			break
	_data_store.current_entry.current_dialogue = dialogue
	_data_store.notify_dialogue_changed(dialogue)
