extends TextureRect

@onready var enable_check: CheckButton = %EnablePortrait


func _ready() -> void:
	enable_check.toggled.connect(
		func(toggled_on: bool):
			if toggled_on:
				show()
			else:
				hide(),
	)
