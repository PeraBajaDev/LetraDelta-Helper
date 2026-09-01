extends MenuButton

var _author_info_window: ConfirmationDialog

@onready var _author_info: PackedScene = preload("uid://c2rhhjqbphfsx")


func _ready() -> void:
	var popup := get_popup()
	popup.index_pressed.connect(_on_item_selected)


func _on_item_selected(index: int):
	match index:
		1:
			if _author_info_window == null:
				_author_info_window = _author_info.instantiate()
				owner.add_child(_author_info_window)
			_author_info_window.show()
