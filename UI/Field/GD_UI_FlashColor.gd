extends ColorRect
class_name UIFlashColor

var texture_amount: float = 0:
	set(value):
		texture_amount = value
		_set_texture_rect_amount(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ActionManager.flash_screen = self

func _set_texture_rect_amount(_v: float):
	material.set_shader_parameter("amount", _v)
