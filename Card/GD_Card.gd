extends Control
class_name Card

signal selection_change
signal is_buy(card: Card)

@export var angle_x_max: float = 0.1
@export var angle_y_max: float = 0.1

@onready var card_texture : TextureRect = $Card
@onready var card_animation_player : AnimationPlayer = $AnimationPlayer

var card_id : int = 0
var card_cost : int = 0
var in_shop : bool = false
var shop_price : int = 2

var is_hover : bool
var is_selected : bool:
	set(value):
		if is_selected and !value:
			card_texture.position.y = 0
		if !is_selected and value:
			card_animation_player.play("Hover")
			_set_card_rotation(0, 0)
		is_selected = value
	get:
		return is_selected

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
	
func _on_card_mouse_entered() -> void:
	is_hover = true
	pass # Replace with function body.

func _on_card_mouse_exited() -> void:
	is_hover = false
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
	var mouse_pos: Vector2 = get_local_mouse_position()
	var diff: Vector2 = (position + Vector2(card_texture.size.x * card_texture.scale.x, card_texture.size.y * card_texture.scale.y)) - mouse_pos
	#print("Mouse: ", mouse_pos)
	#print("Card: ", position + card_anchor.size)
	#print("diff: ", diff)

	var lerp_val_x: float = remap(mouse_pos.x, 0.0, card_texture.size.x * card_texture.scale.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, card_texture.size.y * card_texture.scale.y, 0, 1)
	#print("Lerp val x: ", lerp_val_x)
	#print("lerp val y: ", lerp_val_y)

	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
	#print("Rot x: ", rot_x)
	#print("Rot y: ", rot_y)
	
	_set_card_rotation(rot_x, rot_y)
