extends CanvasLayer

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_un_pause_button_pressed() -> void:
	self.visible = false
	get_tree().paused = false
	audio_stream_player.play()


func _on_main_menu_button_pressed() -> void:
	audio_stream_player.play()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://System/Main Menu/S_Main_Menu.tscn")


func _on_desktop_button_pressed() -> void:
	get_tree().quit()
