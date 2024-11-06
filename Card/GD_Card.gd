extends Control
class_name Card

signal selection_change

@onready var label_name : Label = $Card/Container/Name
@onready var label_description : Label = $Card/Container/Description

var card_cost : int = 0
var card_name : String = "Card name": 
	set(value):
		card_name = value
		label_name.text = card_name
	get:
		return card_name
var card_description : String = "This is a new card description":
	set(value):
		card_description = value
		label_description.text = card_description
	get:
		return card_description

var in_shop : bool = false

var is_selected : bool:
	set(value):
		is_selected = value
		if is_selected:
			label_name.text = card_name + " (Selected)"
		else:
			label_name.text = card_name
	get:
		return is_selected
var is_hover : bool

func _ready() -> void:
	card_name = card_name
	card_description = card_description
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and is_hover and event.is_pressed():
		selected()

func selected():
	is_selected = !is_selected
	emit_signal("selection_change")
	
func _on_card_mouse_entered() -> void:
	is_hover = true
	pass # Replace with function body.

func _on_card_mouse_exited() -> void:
	is_hover = false
	pass # Replace with function body.
