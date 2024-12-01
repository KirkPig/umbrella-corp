extends CanvasLayer
class_name UIPhone

signal start_up_done
signal play_sleeping_done

var time:int = 0
@onready var time_label = $"Control/TextureRect/VSplitContainer/Data/Time Label"
@onready var energy_label = $Control/TextureRect/VSplitContainer/Data/Control/Energy
@onready var energy_progress = $Control/TextureRect/VSplitContainer/Data/Control/TextureProgressBar
@onready var shop_time_label = $"Control/Shop/VSplitContainer/Data/Time Label"
@onready var shop_energy_label = $Control/Shop/VSplitContainer/Data/Control/Energy
@onready var shop_energy_progress = $Control/Shop/VSplitContainer/Data/Control/TextureProgressBar

@onready var action_screen = $Control/TextureRect
@onready var out_of_energy_screen = $"Control/Out of energy"
@onready var shop_screen = $Control/Shop

@onready var gold_panel = $Control/TextureRect/VSplitContainer/money/PanelContainer
@onready var gold_label = $Control/TextureRect/VSplitContainer/money/PanelContainer/HSplitContainer/MarginContainer/Label
@onready var gold_shop_label = $Control/Shop/VSplitContainer/Control/MoneyLabel

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2

@onready var black_screen: Panel = $Control/Screen
var black_screen_value: float = 1:
	set(value):
		var _style = black_screen.get_theme_stylebox("panel")
		_style.bg_color.a = value
		black_screen_value = value

@onready var _screen_label: Label = $Control/Screen/Label
@onready var _moon: TextureRect = $Control/Screen/Moon
var _label_visibility: float = 1:
	set(value):
		_screen_label.modulate.a = value
		_label_visibility = value
var _moon_pos_x: float = 0:
	set(value):
		_moon.position.x = value
		_moon_pos_x = value
var _moon_pos_y: float = 0:
	set(value):
		_moon.position.y = value
		_moon_pos_y = value


func start_up():
	black_screen_value = 1
	black_screen.show()
	var tween: Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "black_screen_value", 0, 0.5)
	await tween.finished
	black_screen.hide()
	start_up_done.emit()

func play_sleeping():
	
	black_screen_value = 0
	black_screen.show()
	
	var tween: Tween
	
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "black_screen_value", 1, 0.2)
	await tween.finished
	
	shop_screen.hide()
	out_of_energy_screen.hide()
	
	var _tween_label_visibility: Tween
	var _tween_moon_pos_x: Tween
	var _tween_moon_pos_y: Tween
	
	_label_visibility = 0
	_moon_pos_x = 350
	_moon_pos_y = 250
	
	_screen_label.show()
	_moon.show()
	
	_tween_label_visibility = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	_tween_label_visibility.tween_property(self, "_label_visibility", 1, 0.5 / GameManager.game_speed)
	_tween_moon_pos_x = create_tween()
	_tween_moon_pos_x.tween_property(self, "_moon_pos_x", -140, 4 / GameManager.game_speed)
	_tween_moon_pos_y = create_tween()
	_tween_moon_pos_y.tween_property(self, "_moon_pos_y", 150, 2 / GameManager.game_speed)
	
	await _tween_moon_pos_y.finished
	
	_tween_moon_pos_y = create_tween()
	_tween_moon_pos_y.tween_property(self, "_moon_pos_y", 250, 2 / GameManager.game_speed)
	
	await get_tree().create_timer(1.5 / GameManager.game_speed)
	_tween_label_visibility = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	_tween_label_visibility.tween_property(self, "_label_visibility", 0, 0.5 / GameManager.game_speed)
	
	await _tween_moon_pos_x.finished
	
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "black_screen_value", 0, 0.2)
	await tween.finished
	
	_screen_label.hide()
	_moon.hide()
	black_screen.hide()
	play_sleeping_done.emit()
	

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
	out_of_energy_screen.visible = (energy <= 0)
	if energy ==0 :
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
