extends Control
class_name SettingController

@onready var pause_screen = $SPauseMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_view_button_pressed() -> void:
	pause_screen.visible = true
	get_tree().paused = true
