extends Label

@export var _data_store: DataStore


func _ready() -> void:
	_data_store.data_loaded.connect(_on_data_loaded)
	_data_store.data_freed.connect(
		func():
			text = "0 / 0 | 0%",
	)


func _on_data_loaded():
	var all_dialogues: Array[Dialogue] = []
	var dialogues_from_entries = _data_store.dialogues_entries.map(
		func(entry: DialogueEntry):
			return entry.dialogues,
	)
	for dialogues in dialogues_from_entries:
		all_dialogues.append_array(dialogues)
	var translated_count: int = all_dialogues.reduce(
		func(count: int, dialogue) -> int:
			if dialogue and not dialogue.content.is_empty():
				return count + 1
			return count,
		0,
	)
	var total = len(all_dialogues)
	var percentaje: float = ((float(translated_count) / total) * 100)

	text = "{0} / {1} | {2}%".format([translated_count, total, "%.2f" % percentaje])
