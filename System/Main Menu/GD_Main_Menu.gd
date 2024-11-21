extends CanvasLayer

func _process(delta):
	pass
		
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://System/S_Main.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
