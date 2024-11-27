extends Control

@export var worker_card: WorkerCardData
@export var resource_card: ResourceCardData
@export var business_card: BusinessCardData
@export var instant_card: InstantCardData

@onready var playing_field: PlayingFieldController = $PlayingField

func _ready() -> void:
	GameManager.gold = 10000
	GameManager.energy = 10000
	GameManager.rng = RandomNumberGenerator.new()
	GameManager.rng.seed = hash("0")

func _on_button_pressed() -> void:
	CardManager.add_card_to_hand(resource_card.card_id)
	pass # Replace with function body.


func _on_add_shop_pressed() -> void:
	CardManager.shop.add_card_to_shop(worker_card.card_id)
	pass # Replace with function body.


func _on_research_pressed() -> void:
	var selected_card = CardManager.get_selected_card()
	if GameManager.can_research(selected_card):
		print("ok")
		ActionManager.action_research()
	else:
		print("not ok")
	pass # Replace with function body.


func _on_test_pressed() -> void:
	var selected_card = CardManager.get_selected_card()
	playing_field.playing_cards(selected_card, Vector2(-300, 500), true)
	CardManager.hand.update_position()
