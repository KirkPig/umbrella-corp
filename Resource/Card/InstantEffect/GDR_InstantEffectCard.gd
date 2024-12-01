extends InstantEffect
class_name InstantEffectCard

@export var effect_start_location : CardManager.ECardLocation
@export var creat_copy : bool = false
@export var amount : int
@export var effect_end_location : CardManager.ECardLocation

func activate(target:Array[Card]) -> void:
	var cards:Array[Card] = CardManager.get_all_card(effect_start_location)
	
	var picked_cards:Array[Card] = []
	while len(picked_cards) < amount or len(picked_cards) == len(cards):
		var card = cards[GameManager.rng.randi() % len(cards)]
		if not picked_cards.has(card):
			picked_cards.append(card)
	
	
	if creat_copy:
		var new_card_list:Array[Card] = []
		for card in picked_cards:
			var new_card = CardManager.add_card_to_hand(card.card_id) 
			new_card_list.append(new_card)
		CardManager.move_cards_to(new_card_list,effect_end_location)
	else:
		CardManager.move_cards_to(picked_cards,effect_end_location)
