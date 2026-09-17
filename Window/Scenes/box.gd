extends TextureRect

@export var _data_store: DataStore

@onready var _portrait_offset: MarginContainer = %"MarginPortrait"


func _ready() -> void:
	_data_store.dialogue_selected.connect(_on_dialogue_selected)


func _on_dialogue_selected(dialogue: Dialogue):
	var style_metadata: Dictionary = JSONHandler.get_style_metadata(_data_store.style)
	if style_metadata.is_empty():
		return
	var boxes: Array[Dictionary] = []
	boxes.assign(style_metadata.get("boxes", []) as Array[Dictionary])
	var box_index: int = boxes.find_custom(
		func(box: Dictionary) -> bool:
			return box.get("name", "") == dialogue.box_type,
	)
	if box_index == -1:
		return
	var box_texture = boxes[box_index].get("texture")
	var portrait_offset_x: float = boxes[box_index].get("portrait_offset_x", 0)
	var portrait_offset_y: float = boxes[box_index].get("portrait_offset_y", 0)
	if box_texture == null:
		return
	const STYLE_DIR = "user://Styles"
	var image_path = STYLE_DIR.path_join(_data_store.style).path_join(box_texture)
	texture = ImageTexture.create_from_image(Image.load_from_file(image_path))
	_portrait_offset.add_theme_constant_override("margin_left", int(portrait_offset_x))
	_portrait_offset.add_theme_constant_override("margin_top", int(portrait_offset_y))
