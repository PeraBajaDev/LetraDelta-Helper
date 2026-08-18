extends CheckBox

@export var _data_store: DataStore

var _selected_dialogue: Dialogue


func _ready() -> void:
	_data_store.data_loaded.connect(_on_data_loaded)
	_data_store.data_freed.connect(_on_data_freed)
	_data_store.entry_selected.connect(_on_entry_selected)
	toggled.connect(_on_toggled)


func _on_data_loaded() -> void:
	UIWatcher.watch(self, _data_store.dialogue_selected, _on_dialogue_selected)


func _on_entry_selected(_entry: DialogueEntry):
	disabled = true
	_selected_dialogue = null


func _on_data_freed() -> void:
	disabled = true
	_selected_dialogue = null


func _on_dialogue_selected(dialogue: Dialogue):
	disabled = false
	_selected_dialogue = dialogue
	button_pressed = dialogue.needs_review


func _on_toggled(value: bool):
	if _selected_dialogue:
		_selected_dialogue.mark_for_review(value)
