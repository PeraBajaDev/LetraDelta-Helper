extends ConfirmationDialog

enum SearchTypes {
	DIALOGUE,
	KEY,
}

@export var _data_store: DataStore

@onready var _search_type: OptionButton = %"SearchType"
@onready var _case_sensitive: CheckBox = %"CaseSensitive"
@onready var _search_for: LineEdit = %"SearchFor"
@onready var _search_results_window: SearchResultsWindow = $"SearchResults"


func _ready() -> void:
	_data_store.data_loaded.connect(_on_data_loaded)
	_data_store.data_freed.connect(_on_data_freed)
	confirmed.connect(_on_confirmed)
	get_ok_button().disabled = true


func _on_data_loaded():
	_search_type.disabled = false
	_case_sensitive.disabled = false
	_search_for.editable = true
	get_ok_button().disabled = false


func _on_data_freed():
	_search_type.disabled = true
	_case_sensitive.disabled = true
	_search_for.editable = false
	get_ok_button().disabled = true


func _on_confirmed():
	var result: Array[Dialogue]
	match _search_type.selected:
		SearchTypes.DIALOGUE:
			result = _data_store.filter_dialogues_by_content(
				_search_for.text,
				_case_sensitive.button_pressed,
			)
		SearchTypes.KEY:
			result = _data_store.filter_dialogues_by_key(
				_search_for.text,
				_case_sensitive.button_pressed,
			)
	_search_results_window.show_results(result)
