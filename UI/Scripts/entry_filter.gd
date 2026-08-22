extends OptionButton

@export var _data_store: DataStore


func _ready() -> void:
	item_selected.connect(_on_item_selected)
	_data_store.data_loaded.connect(
		func():
			disabled = false,
	)
	_data_store.data_freed.connect(
		func():
			disabled = true,
	)


func _on_item_selected(index):
	match index:
		0:
			pass
		1:
			_data_store.filter_entries_by_state(Dialogue.State.NOT_TRANSLATED)
		2:
			_data_store.filter_entries_by_state(Dialogue.State.TRANSLATED)
		3:
			_data_store.filter_entries_by_state(Dialogue.State.NEEDS_REVIEW)
		4:
			_data_store.filter_entries_by_state(Dialogue.State.INVALID_TAGS)
		5:
			_data_store.filter_entries_by_state(Dialogue.State.INVALID_SIGNS)
	pass
