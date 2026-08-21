extends Label

@export var data_store: DataStore

var _selected_dialogue: Dialogue


func _ready() -> void:
	data_store.dialogue_selected.connect(_on_dialogue_selected)


func _on_dialogue_selected(dialogue: Dialogue):
	_selected_dialogue = dialogue
	UIWatcher.watch(self, dialogue.content_changed, _on_content_change)
	_on_content_change()


func _on_content_change():
	var result: DialogueStateResult = _selected_dialogue.get_state_report()
	if result.state == Dialogue.State.INVALID_TAGS:
		var missing_tags: PackedStringArray = result.context[0]
		var extra_tags: PackedStringArray = result.context[1]
		var wrong_order_message: String = "Wrong order" if result.context[2] else ""
		show()
		text = tr("INVALID_TAGS_LABEL") + " missing: " + ", ".join(missing_tags) + " extra: " + ", ".join(
			extra_tags
		) + " " + wrong_order_message
	else:
		hide()
