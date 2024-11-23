extends Control

@onready var deck_button = $Control/VSplitContainer/ViewButton
@onready var deck_button_label = $Control/VSplitContainer/ViewButton/CardsLabel

@onready var deck_card = %DeckCard

@onready var deck_view = $CanvasLayer
@onready var card_grid = %DeckGridContainer


var card_number : int  = 0 :
	set(value):
		card_number = value
		deck_button_label.text = str(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CardManager.deck = %DeckCard

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_all_card() -> Array[Node]:
	return deck_card.get_children()
	
func _on_deck_card_child_order_changed() -> void:
	card_number = deck_card.get_child_count()


func _on_closed_button_pressed() -> void:
	deck_view.visible = false
	for card in card_grid.get_children():
		card.reparent(deck_card)


func _on_view_button_pressed() -> void:
	deck_view.visible = true
	for card in deck_card.get_children():
		card.reparent(card_grid)
