extends InstantEffect
class_name InstantEffectCardChange

enum ECardChange{
	WORKER,
	RESOURCE
}

@export var effect_location : CardManager.ECardLocation
@export var card_change_from : ECardChange
@export var card_change_to : ECardChange
@export var amount : int

func activate(target:Array[Card]) -> void:
	var cards:Array[Card] = CardManager.get_all_card(effect_location)
	
	var picked_cards = []
	var new_cards_list = []
	
	for card in cards:
		if len(picked_cards) == amount:
			break
		match card_change_from:
			ECardChange.WORKER:
				if card is WorkerCard:
					picked_cards.append(card)
			ECardChange.RESOURCE:
				if card is ResourceCard:
					picked_cards.append(card)
					
	for card in picked_cards:
		match card_change_to:
			ECardChange.WORKER:
				var new_card = CardManager.add_card_to_hand(0) 
				new_cards_list.append(new_card)
			ECardChange.RESOURCE:
				while true:
					var card_id = GameManager.card_pool[GameManager.rng.randi() % GameManager.card_pool.size()]
					if card_id >= 2000 and card_id < 3000:
						var new_card = CardManager.add_card_to_hand(card_id) 
						new_cards_list.append(new_card)	
						break
		
	CardManager.move_cards_to(new_cards_list,effect_location)
	CardManager.move_cards_to(picked_cards,CardManager.ECardLocation.played)
