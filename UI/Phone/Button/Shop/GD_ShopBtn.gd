extends Control
signal shop_btn_pressed

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_view_button_pressed() -> void:
	shop_btn_pressed.emit()
	audio_stream_player.play()
