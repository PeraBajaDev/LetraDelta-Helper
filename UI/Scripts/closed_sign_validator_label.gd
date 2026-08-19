extends Label

@export var data_store: DataStore

var _selected_dialogue: Dialogue


func _ready() -> void:
	data_store.dialogue_selected.connect(_on_dialogue_selected)


func _on_dialogue_selected(dialogue: Dialogue):
	_selected_dialogue = dialogue
	UIWatcher.watch(self, dialogue.content_changed, _on_content_change)


func _on_content_change():
	var result: DialogueStateResult = _selected_dialogue.get_state_report()
	if result.state == Dialogue.State.INVALID_SIGNS:
		show()
		text = tr("INVALID_SIGNS_LABEL") + " " + ", ".join(result.context)
	else:
		hide()
