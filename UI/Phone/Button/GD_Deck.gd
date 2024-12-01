extends Control

@onready var deck_button = $Control/VSplitContainer/ViewButton
@onready var deck_button_label = $Control/VSplitContainer/ViewButton/Control/Control/PanelContainer/HBoxContainer/CenterContainer/CardsLabel
@onready var deck_card = %DeckCard

@onready var deck_view = $SDeckPile
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var card_number : int  = 0 :
	set(value):
		card_number = value
		deck_button_label.text = str(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CardManager.deck = %DeckCard
	deck_view.close_view.connect(_on_closed_button_pressed)

func get_all_card() -> Array[Node]:
	return deck_card.get_children()
	
func _on_deck_card_child_order_changed() -> void:
	card_number = deck_card.get_child_count()

func _on_closed_button_pressed() -> void:
	deck_view.visible = false
	for card in deck_view.get_all_card():
		card.reparent(deck_card)
	audio_stream_player.play()


func _on_view_button_pressed() -> void:
	deck_view.visible = true
	deck_view.move_card_to_pile(deck_card.get_children())
	audio_stream_player.play()
