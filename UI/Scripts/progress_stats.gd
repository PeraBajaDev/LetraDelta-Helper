extends Label

@export var _data_store: DataStore

var _all_dialogues: Array[Dialogue]


func _ready() -> void:
	_data_store.data_loaded.connect(_on_data_loaded)
	_data_store.data_freed.connect(
		func():
			text = "0 / 0 | 0%"
			_all_dialogues = [],
	)
	_data_store.dialogue_selected.connect(_on_dialogue_selected)


func _on_dialogue_selected(dialogue: Dialogue):
	# Calling deferred to wait similar dialogues changes
	UIWatcher.watch(self, dialogue.content_changed, change_progress.call_deferred)


func _on_data_loaded():
	_all_dialogues = []
	var dialogues_from_entries = _data_store.dialogues_entries.map(
		func(entry: DialogueEntry):
			return entry.dialogues,
	)
	for dialogues in dialogues_from_entries:
		_all_dialogues.append_array(dialogues)
	change_progress()


func change_progress():
	var translated_count: int = _all_dialogues.reduce(
		func(count: int, dialogue) -> int:
			if dialogue and not dialogue.content.is_empty():
				return count + 1
			return count,
		0,
	)
	var total = len(_all_dialogues)
	var percentaje: float = ((float(translated_count) / total) * 100)

	text = "{0} / {1} | {2}%".format([translated_count, total, "%.2f" % percentaje])
