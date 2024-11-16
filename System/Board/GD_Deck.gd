extends Control

@onready var deck_button = $Control/Button
@onready var deck_card = $DeckCard

var card_number : int  = 0 :
	set(value):
		card_number = value
		deck_button.text = "Deck ("+str(value)+")"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CardManager.deck = $DeckCard

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_deck_card_child_order_changed() -> void:
	card_number = deck_card.get_child_count()
