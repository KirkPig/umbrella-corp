extends Control
class_name Card

@export var card_cost : int = 0
@export var card_name : String = "Card"
@export var card_description : String = "This is a card description"

var label_name : Label
var label_description : Label

var is_selected : bool
var is_hover : bool

func _init(cost: int, name: String, description: String):
	card_cost = cost
	card_name = name
	card_description = description

func _ready() -> void:
	label_name = get_child(0).get_child(0).get_child(0)
	label_description = get_child(0).get_child(0).get_child(1)
	
	label_name.text = card_name
	label_description.text = card_description

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and is_hover and event.is_pressed():
		is_selected = !is_selected
		if is_selected:
			label_name.text = card_name + " (Selected)"
		else:
			label_name.text = card_name
	
func _on_card_mouse_entered() -> void:
	is_hover = true
	pass # Replace with function body.

func _on_card_mouse_exited() -> void:
	is_hover = false
	pass # Replace with function body.
