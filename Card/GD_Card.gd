extends Control
class_name Card

signal selection_change
signal is_buy(card: Card)

signal card_scaling_up
signal card_play(_card: Card)

var tween_selected: Tween
var tween_hover: Tween
var tween_rot: Tween
var tween_moving: Tween
var tween_bouncing: Tween

@export var angle_x_max: float = 0.05
@export var angle_y_max: float = 0.05
@export var toggle_up_pixel: float = 50

@export_category("Oscillator")
@export var spring: float = 500.0
@export var damp: float = 20.0
@export var velocity_multiplier: float = 10.0

var displacement: float = 0.0 
var oscillator_velocity: float = 0.0

var last_pos: Vector2
var velocity: Vector2

@onready var card_texture : TextureRect = $Card

var card_id : int = 0
var card_cost : int = 0
var in_shop : bool = false
var shop_price : int = 2

var is_disable_hover: bool = false

var is_hover : bool
var is_selected : bool:
	set(value):
		if tween_selected and tween_selected.is_running():
			tween_selected.kill()
		if is_selected and !value:
			card_texture.position.y = 0
		if !is_selected and value:
			tween_selected = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			tween_selected.tween_property(card_texture, "position", Vector2(0, -toggle_up_pixel), 0.25)
			_set_card_rotation_effect(0, 0)
		is_selected = value

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	rotate_velocity(delta)

func bouncing_card() -> void:
	if tween_bouncing and tween_bouncing.is_running():
		tween_bouncing.kill()
	scale = Vector2.ONE
	tween_bouncing = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_speed_scale(GameManager.game_speed)
	tween_bouncing.tween_property(self, "scale", Vector2(1.25, 1.25), 1.2)
	await get_tree().create_timer(0.6 / GameManager.game_speed).timeout
	emit_signal("card_scaling_up")
	card_play.emit(self)
	await get_tree().create_timer(0.2 / GameManager.game_speed).timeout
	tween_bouncing.kill()
	tween_bouncing = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC).set_speed_scale(GameManager.game_speed)
	tween_bouncing.tween_property(self, "scale", Vector2.ONE, 0.7)
	pass

func handle_mouse_click(event: InputEvent) -> void:
	if event is not InputEventMouseButton: return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	if !is_hover: return 
	if !event.is_pressed(): return
	
	selected()

func selected():
	if in_shop:
		emit_signal("is_buy", self)
		return
	is_selected = !is_selected
	emit_signal("selection_change")

func set_base_data(data: CardData):
	card_id = data.card_id
	card_texture.texture = data.card_texture
	shop_price = data.shop_price

func change_card_position(_pos: Vector2, _time: float):
	if tween_moving and tween_moving.is_running():
		tween_moving.kill()
	tween_moving = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.NOTIFICATION_PREDELETE)
	tween_moving.tween_property(self, "position", _pos, _time)

func set_card_hand_position(_card_pos: int, _in_hand: int, _min_x: float, _max_x: float, _card_min_x: float, in_hand: bool):
	var _middle_pos = (_max_x + _min_x) / 2
	var _pos_x: float
	var _pos_y: float
	if _in_hand == 1:
		_pos_x = _middle_pos
		_pos_y = 0
	else:
		_pos_x = remap(_card_pos, 0, _in_hand - 1, 
			max(_min_x, _middle_pos - (_card_min_x / 2 * (_in_hand - 1))), 
			min(_max_x, _middle_pos + (_card_min_x / 2 * (_in_hand - 1))),
		)
		_pos_y = remap(abs(_pos_x - _middle_pos), 0, _middle_pos, 0, 20)
	if !in_hand:
		_pos_y = 0
	change_card_position(Vector2(_pos_x, _pos_y), 0.2 / GameManager.game_speed)
	z_index = _card_pos

func set_card_pile_position(_in_hand: int, card_gap:int):
	var _pos_x: float = _in_hand * card_gap
	var _pos_y: float = 0
	change_card_position(Vector2(_pos_x, _pos_y), 0.2)
	z_index = _in_hand

func _on_card_mouse_entered() -> void:
	if is_disable_hover: return
	is_hover = true
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1.05, 1.05), 0.4)

func _on_card_mouse_exited() -> void:
	if is_disable_hover: return
	is_hover = false
	if tween_rot and tween_rot.is_running():
		tween_rot.kill()
	tween_rot = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween_rot.tween_property(card_texture.material, "shader_parameter/x_rot", 0.0, 0.4)
	tween_rot.tween_property(card_texture.material, "shader_parameter/y_rot", 0.0, 0.4)
	
	# Reset scale
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2.ONE, 0.4)
	_set_card_rotation_effect(0, 0)

func _set_card_rotation_effect(x: float, y: float):
	card_texture.material.set_shader_parameter("x_rot", x)
	card_texture.material.set_shader_parameter("y_rot", y)

func _on_card_gui_input(event: InputEvent) -> void:
	handle_mouse_click(event)
	
	# TODO: Don't compute rotation when moving the card
	if is_selected: return
	if not event is InputEventMouseMotion: return
	if is_disable_hover: return
	# Handles rotation effect
	var mouse_pos: Vector2 = card_texture.get_local_mouse_position()
	var lerp_val_x: float = remap(mouse_pos.x, 0.0, card_texture.size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, card_texture.size.y, 0, 1)
	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
	_set_card_rotation_effect(rot_x, rot_y)

# Card rotation as it moved
func rotate_velocity(delta: float) -> void:
	var center_pos: Vector2 = position + pivot_offset
	# Compute the velocity
	velocity = (position - last_pos) / delta
	last_pos = position
	
	oscillator_velocity += velocity.normalized().x * velocity_multiplier
	
	# Oscillator stuff
	var force = -spring * displacement - damp * oscillator_velocity
	oscillator_velocity += force * delta
	displacement += oscillator_velocity * delta
	
	rotation = deg_to_rad(displacement)
