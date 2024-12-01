extends Control

@export var worker_card: WorkerCardData
@export var resource_card: ResourceCardData
@export var business_card: BusinessCardData
@export var instant_card: InstantCardData

@onready var playing_field: PlayingFieldController = $PlayingField
@onready var business_field: BusinessFieldController = $BusinessField

func _ready() -> void:
	GameManager.gold = 10000
	GameManager.energy = 10000
	GameManager.rng = RandomNumberGenerator.new()
	GameManager.rng.seed = hash("0")
	GameManager.game_speed = 2.5
	
	CardManager.hand = $Hand
	CardManager.business_field = business_field
	for i in range(2000, 2015):
		CardManager.unlock_resource(i)

func _on_button_pressed() -> void:
	CardManager.add_card_to_hand(2000)
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


func _on_test_business_pressed() -> void:
	pass # Replace with function body.
