extends InstantEffect
class_name InstantEffectCard


@export var effect_start_location : CardManager.ECardLocation
@export var amount : int
@export var effect_end_location : CardManager.ECardLocation


func activate(target:Array[Card]) -> void:
	var cards:Array[Card] = CardManager.get_all_card(effect_start_location)
	
	var picked_cards = []
	while len(picked_cards) < amount or len(picked_cards) == len(cards):
		var card = cards[GameManager.rng.randi() % len(cards)]
		if not picked_cards.has(card):
			picked_cards.append(card)
			
	CardManager.move_cards_to(picked_cards,effect_end_location)
