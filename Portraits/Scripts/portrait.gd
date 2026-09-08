extends TextureRect

@export var _data_store: DataStore

@onready var _enable_check: CheckButton = %EnablePortrait


func _ready() -> void:
	_enable_check.toggled.connect(
		func(toggled_on: bool):
			if toggled_on:
				show()
			else:
				hide(),
	)
	_data_store.data_loaded.connect(_on_data_loaded)
	_data_store.dialogue_selected.connect(_on_dialogue_selected)


func _on_data_loaded() -> void:
	pass


func _on_dialogue_selected(dialogue: Dialogue) -> void:
	var emotion_tag: String = DialogueParser.get_emotion_tag(dialogue.content)
	if not dialogue.speaker or not emotion_tag:
		_enable_check.button_pressed = false
		return

	_enable_check.button_pressed = true
	var style_metadata := JSONHandler.get_style_metadata(_data_store.style)
	if style_metadata.is_empty():
		return
	var speakers: Array = style_metadata["speakers"]
	var by_name = func(speaker: Dictionary):
		return speaker["name"] == dialogue.speaker
	var speaker_index = speakers.find_custom(by_name)
	if speaker_index == -1:
		var placeholder = PlaceholderTexture2D.new()
		placeholder.size = Vector2i(100, 100)
		texture = placeholder
		return
	var tag_pattern: String = style_metadata["tag_pattern"]
	var emotion_tag_value: int = tag_pattern.find(emotion_tag.trim_prefix(r"\E"))
	if emotion_tag_value == -1:
		return
	var portrait_image_path: String = speakers[speaker_index]["character_tag_pattern"].format(
		{ "tag": emotion_tag_value }
	)
	var image_path = "user://Styles".path_join(_data_store.style).path_join(portrait_image_path)
	if not FileAccess.file_exists(image_path):
		var placeholder = PlaceholderTexture2D.new()
		placeholder.size = Vector2i(100, 100)
		texture = placeholder
	elif portrait_image_path:
		texture = ImageTexture.create_from_image(Image.load_from_file(image_path))
