extends Control
class_name Card

signal selection_change
signal is_buy(card: Card)

@onready var card_anchor : Control = $Card
@onready var card_texture : Sprite2D = $Card/Texture
@onready var card_animation_player : AnimationPlayer = $AnimationPlayer

var card_id : int = 0
var card_cost : int = 0
var in_shop : bool = false
var shop_price : int = 2

var is_hover : bool
var is_selected : bool:
	set(value):
		if is_selected and !value:
			card_anchor.position.y = 0
		if !is_selected and value:
			card_animation_player.play("Hover")
		is_selected = value
	get:
		return is_selected

func _ready() -> void:
	pass

func _input(event: InputEvent) -> void:
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
	pass # Replace with function body.
