extends TextEdit
class_name DialogueEdit
@export var _data_store: DataStore
@onready var _replace_similar_entries_check: CheckBox = $ReplaceSimilar


func _ready() -> void:
	text_changed.connect(_on_text_changed)
	_data_store.data_loaded.connect(_on_data_loaded)
	_data_store.data_freed.connect(clear)


func _on_data_loaded():
	UIWatcher.watch(self, _data_store.entry_selected, _on_current_entry_changed)


func _on_current_entry_changed(entry: DialogueEntry) -> void:
	if entry == null or entry.current_dialogue == null:
		text = ""
		editable = false
	UIWatcher.watch(self, entry.current_dialogue_changed, _on_dialogue_changed)


func _on_dialogue_changed(dialogue: Dialogue) -> void:
	if dialogue == null:
		return
	editable = true
	var caret_column := get_caret_column()
	var caret_line := get_caret_line()
	text = dialogue.content
	set_caret_line(caret_line)
	set_caret_column(caret_column)


func _on_text_changed() -> void:
	var current_dialogue := _data_store.current_entry.current_dialogue
	if _replace_similar_entries_check.button_pressed:
		_replace_similar_entries()
	else:
		current_dialogue.content = text


func _replace_similar_entries():
	var current_dialogue := _data_store.current_entry.current_dialogue
	var all_dialogues: Array[Dialogue] = []
	for entry in _data_store.dialogues_entries:
		all_dialogues.append_array(entry.dialogues)
	for dialogue in all_dialogues:
		if current_dialogue.original_content == dialogue.original_content:
			dialogue.content = text
