extends ItemList
class_name SimilarEntriesList
var _data_file: DataFile
var data_file: DataFile:
	get:
		return data_file
	set(value):
		if value == null:
			return
		_data_file = value
		_data_file.current_entry_changed.connect(_on_current_entry_changed)


func _ready() -> void:
	item_selected.connect(_on_item_selected)


func _on_current_entry_changed():
	if not _data_file.current_entry.current_dialogue_changed.is_connected(
		_on_current_dialogue_changed
	):
		_data_file.current_entry.current_dialogue_changed.connect(_on_current_dialogue_changed)


func _on_current_dialogue_changed():
	clear()
	var selected_dialogue := _data_file \
			.current_entry \
			.current_dialogue
	for entry in _data_file.dialogues_entries:
		for dialogue: Dialogue in entry.dialogues:
			if dialogue.key == selected_dialogue.key:
				continue
			if dialogue.original_content == selected_dialogue.original_content:
				add_item(dialogue.key)


func _on_item_selected(index: int):
	var similar_dialogue_key = get_item_text(index)
	for entry in _data_file.dialogues_entries:
		if entry.id in similar_dialogue_key:
			_data_file.current_entry = entry
			entry.current_dialogue = entry.dialogues.filter(
				func(dialogue: Dialogue):
					return (dialogue.key == similar_dialogue_key),
			)[0]
