extends Control

@onready var discard_button = $Control/VSplitContainer/ViewButton
@onready var discard_button_label = $Control/VSplitContainer/ViewButton/Control/Control/PanelContainer/HBoxContainer/CenterContainer/CardsLabel
@onready var discard_card = $DiscardCard

@onready var discard_view = $SDiscardPile

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var card_number : int  = 0 :
	set(value):
		card_number = value
		discard_button_label.text = str(value)

func _ready() -> void:
	CardManager.discarded = $DiscardCard
	discard_view.close_view.connect(_on_closed_button_pressed)

func get_all_card() -> Array[Node]:
	return discard_card.get_children()

func _on_discard_card_child_order_changed() -> void:
	card_number = discard_card.get_child_count()

func _on_closed_button_pressed() -> void:
	discard_view.visible = false
	for card in discard_view.get_all_card():
		card.reparent(discard_card)
	audio_stream_player.play()

func _on_view_button_pressed() -> void:
	discard_view.visible = true
	discard_view.move_card_to_pile(discard_card.get_children())
	audio_stream_player.play()
