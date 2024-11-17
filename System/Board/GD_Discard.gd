extends Control

@onready var discard_button = $Control/Button
@onready var discard_card = $DiscardCard

@onready var discard_view = $CanvasLayer
@onready var discard_grid = %DiscardGridContainer

var card_number : int  = 0 :
	set(value):
		card_number = value
		discard_button.text = "Discard Pile ("+str(value)+")"

func _ready() -> void:
	CardManager.discarded = $DiscardCard
# Called when the node enters the scene tree for the first time.


func get_all_card() -> Array[Node]:
	return discard_card.get_children()

func _on_discard_card_child_order_changed() -> void:
	card_number = discard_card.get_child_count()


func _on_button_pressed() -> void:
	discard_view.visible = true
	discard_button.visible = false
	for card in discard_card.get_children():
		card.reparent(discard_grid)


func _on_closed_button_pressed() -> void:
	discard_view.visible = false
	discard_button.visible = true
	for card in discard_grid.get_children():
		card.reparent(discard_card)
