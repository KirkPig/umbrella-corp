extends Control
class_name Card

signal selection_change
signal is_buy(card: Card)

var tween_selected: Tween
var tween_hover: Tween
var tween_rot: Tween

@export var angle_x_max: float = 0.05
@export var angle_y_max: float = 0.05

@onready var card_texture : TextureRect = $Card

var card_id : int = 0
var card_cost : int = 0
var in_shop : bool = false
var shop_price : int = 2

var is_hover : bool
var is_selected : bool:
	set(value):
		if tween_selected and tween_selected.is_running():
			tween_selected.kill()
		if is_selected and !value:
			card_texture.position.y = 0
		if !is_selected and value:
			tween_selected = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			tween_selected.tween_property(card_texture, "position", Vector2(0, -100), 0.25)
			_set_card_rotation(0, 0)
		is_selected = value

func _ready() -> void:
	pass

func handle_mouse_click(event: InputEvent) -> void:
	if event is InputEventMouseButton and is_hover and event.is_pressed():
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
		_pos_y = remap(abs(_pos_x - _middle_pos), 0, _middle_pos, 0, 30)
	if !in_hand:
		_pos_y = 0
	# TODO: Animation on the change position
	# TODO(OPTIONAL): More on the rotation randomize with pattern
	position = Vector2(_pos_x, _pos_y)
	
	
func _on_card_mouse_entered() -> void:
	is_hover = true
	if tween_hover and tween_hover.is_running():
		tween_hover.kill()
	tween_hover = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween_hover.tween_property(self, "scale", Vector2(1.05, 1.05), 0.4)
	pass # Replace with function body.

func _on_card_mouse_exited() -> void:
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
	_set_card_rotation(0, 0)
	pass # Replace with function body.

func _set_card_rotation(x: float, y: float):
	card_texture.material.set_shader_parameter("x_rot", x)
	card_texture.material.set_shader_parameter("y_rot", y)

func _on_card_gui_input(event: InputEvent) -> void:
	
	#print("--------------------------")
	handle_mouse_click(event)
	
	# TODO: Don't compute rotation when moving the card
	if is_selected: return
	if not event is InputEventMouseMotion: return
	
	# Handles rotation
	# Get local mouse pos
	var mouse_pos: Vector2 = card_texture.get_local_mouse_position()
	var lerp_val_x: float = remap(mouse_pos.x, 0.0, card_texture.size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, card_texture.size.y, 0, 1)
	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
	#print("Mouse: ", mouse_pos)
	#print("Card: ", position + card_anchor.size)
	#print("diff: ", diff)
	#print("Lerp val x: ", lerp_val_x)
	#print("lerp val y: ", lerp_val_y)
	#print("Rot x: ", rot_x)
	#print("Rot y: ", rot_y)
	
	_set_card_rotation(rot_x, rot_y)
