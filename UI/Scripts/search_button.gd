extends Button


func _ready() -> void:
	var search_window: Window = $"Search"
	pressed.connect(search_window.show)
