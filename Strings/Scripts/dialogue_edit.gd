class_name DialogueEdit
extends TextEdit

enum SpellMenuOptions {
	SEPARATOR = 1000,
	GIVE_SUGGESTIONS = 1001,
	ADD_TO_DICTIONARY = 1002,
}

@export var _data_store: DataStore

var regex := RegEx.new()

var current_word: String = ""
var _native_menu: PopupMenu

@onready var _replace_similar_entries_check: CheckBox = %ReplaceSimilar

@onready var _spell_checker: SpellChecker = SpellChecker.new()


func _ready() -> void:
	text_changed.connect(_on_text_changed)
	_data_store.data_loaded.connect(_on_data_loaded)
	_data_store.data_freed.connect(clear)
	var dictionary_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOWNLOADS).path_join("es_ES")
	if not _spell_checker.load_dictionary(dictionary_dir + ".aff", dictionary_dir + ".dic"):
		push_warning("Dictionary failed loading")
	regex.compile(r"(?<!\\\p{L})\p{L}+(?=[^\p{L}]|\Z)")
	_native_menu = get_menu()
	_native_menu.about_to_popup.connect(_on_menu_about_to_popup)
	_native_menu.id_pressed.connect(_on_menu_option_selected)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		current_word = _get_word_under_position(event.position)


func _draw() -> void:
	var line_count := get_line_count()

	for line_idx in range(line_count):
		var line_text := get_line(line_idx)

		for result in regex.search_all(line_text):
			var word := result.get_string()

			if not _spell_checker.spell(word):
				_underline_word(line_idx, result.get_start(), result.get_end())


func _get_word_under_position(pos_local: Vector2) -> String:
	var pos_texto: Vector2i = get_line_column_at_pos(Vector2i(pos_local))
	var line: int = pos_texto.y
	var column: int = pos_texto.x

	if line < 0 or column < 0 or line >= get_line_count():
		return ""

	set_caret_line(line)
	set_caret_column(column)

	var word: String = get_word_under_caret()
	if _spell_checker.spell(word):
		return ""
	return word


func _on_menu_about_to_popup() -> void:
	_native_menu.item_count = _native_menu.get_item_index(MENU_REDO) + 1
	_native_menu.position += Vector2i.UP * 150
	if current_word.is_empty():
		return
	_native_menu.add_separator(
		"Acciones para '" + current_word + "'",
		SpellMenuOptions.SEPARATOR,
	)
	_native_menu.add_item("Show suggestions", SpellMenuOptions.GIVE_SUGGESTIONS)
	_native_menu.add_item("Add to dictionary", SpellMenuOptions.ADD_TO_DICTIONARY)


func _on_menu_option_selected(id: int) -> void:
	match id:
		SpellMenuOptions.GIVE_SUGGESTIONS:
			var suggestions_submenu = PopupMenu.new()

			for suggestion in _spell_checker.suggest(current_word):
				suggestions_submenu.add_item(suggestion)
			suggestions_submenu.max_size = Vector2i(200, 100)
			var item_index = _native_menu.get_item_index(id)
			_native_menu.set_item_submenu_node(item_index, suggestions_submenu)
			var mouse_pos := get_global_mouse_position() as Vector2i
			suggestions_submenu.popup(Rect2i(mouse_pos.x, mouse_pos.y - 40, 0, 0))
			var index: int = await suggestions_submenu.index_pressed

			var word_suggestion: String = suggestions_submenu.get_item_text(index)
			var re = RegEx.create_from_string(r"(\b)%s(\b)" % current_word)
			text = re.sub(text, "${1}" + word_suggestion + "${2}")
			current_word = ""
		SpellMenuOptions.ADD_TO_DICTIONARY:
			if not current_word:
				return
			_spell_checker.add_word(current_word)

	print("añadiendo", _spell_checker.spell(current_word))


func _underline_word(line: int, start_col: int, end_col: int) -> void:
	var rect_start := get_rect_at_line_column(line, start_col)
	var rect_end := get_rect_at_line_column(line, end_col)

	if rect_start == Rect2i() or rect_end == Rect2i():
		return

	var y_pos := rect_start.position.y + rect_start.size.y - 2.0
	var point_a := Vector2(rect_start.position.x + 5, y_pos)
	var point_b := Vector2(rect_end.position.x + 5, y_pos)

	draw_line(point_a, point_b, Color(0.9, 0.2, 0.2), 2.0)


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
