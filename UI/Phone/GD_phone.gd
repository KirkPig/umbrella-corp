extends CanvasLayer

var time:int = 0
@onready var time_label = $"Control/TextureRect/VSplitContainer/Data/Time Label"
@onready var energy_label = $Control/TextureRect/VSplitContainer/Data/Control/Energy
@onready var energy_progress = $Control/TextureRect/VSplitContainer/Data/Control/TextureProgressBar
@onready var shop_time_label = $"Control/Shop/VSplitContainer/Data/Time Label"
@onready var shop_energy_label = $Control/Shop/VSplitContainer/Data/Control/Energy
@onready var shop_energy_progress = $Control/Shop/VSplitContainer/Data/Control/TextureProgressBar

@onready var action_screen = $Control/TextureRect
@onready var out_of_energy_screen = $"Control/Our of energy"
@onready var shop_screen = $Control/Shop

@onready var gold_panel = $Control/TextureRect/VSplitContainer/money/PanelContainer
@onready var gold_label = $Control/TextureRect/VSplitContainer/money/PanelContainer/HSplitContainer/MarginContainer/Label
@onready var gold_shop_label = $Control/Shop/VSplitContainer/Control/MoneyLabel

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_energy_change.connect(_on_energy_change)
	GameManager.gold_change.connect(_on_gold_change)

func app_push_sound() -> void:
	audio_stream_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	time += 1
	var hour :int= int(time/3600)
	var minute :String=  str(int(time/60)) if int(time/60) > 9 else "0" + str(int(time/60))
	var sec :String= str(int(time%60)) if int(time%60) > 9 else "0" + str(int(time%60))
	time_label.text = str(hour) + ":" + minute + ":" + sec \
					if hour > 0 else minute + ":" + sec
	shop_time_label.text = str(hour) + ":" + minute + ":" + sec \
					if hour > 0 else minute + ":" + sec

func _on_energy_change(energy:int) -> void:
	energy_label.text = str(energy*25) + "%"
	shop_energy_label.text = str(energy*25) + "%"
	energy_progress.value = energy
	shop_energy_progress.value = energy
	action_screen.visible = energy > 0
	if energy ==0 :
		out_of_energy_screen.visible = true
		audio_stream_player_2.play()
func _on_gold_change(gold:int) -> void:
	gold_label.text = "$ "+str(gold)
	gold_shop_label.text = "$ "+str(gold)

func _on_shop_shop_btn_pressed() -> void:
	action_screen.visible = false
	shop_screen.visible = true
	app_push_sound()

func _on_close_shop_pressed() -> void:
	action_screen.visible = true
	shop_screen.visible = false
	app_push_sound()
