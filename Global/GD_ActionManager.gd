extends Node

var action_list: ActionListController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Section: Actions
func action_work(business: BusinessCard):
	var selected_card = CardManager.get_selected_card()
	
	# TODO: More on can not work if energy is not enough
	if !action_list.can_work(selected_card):
		return
		
	# TODO: Chnage to check rate
	for card in selected_card:
		if card.is_selected:
			var data = business.gather_resource()
			var new_card = CardManager.add_card_to_deck(data)
			CardManager.discard(new_card)
	CardManager.discards(selected_card)
	CardManager.fill_hand()
	
	GameManager.energy = GameManager.energy - action_list.energy_cost_work
	action_list.reset_list()
	
func action_discard():
	CardManager.discards(CardManager.get_selected_card())
	CardManager.fill_hand()
	
	GameManager.energy = GameManager.energy - action_list.energy_cost_discard
	action_list.reset_list()

func action_sell():
	var selected_card: Array[Card] = CardManager.get_selected_card()
	var _dict : Dictionary = {}
	var price = 0
	for card : ResourceCard in selected_card:
		if card.card_id in _dict:
			_dict[card.card_id] += 1
		else:
			_dict[card.card_id] = 1
		price = price + card.yield_score
		GameManager.gold = GameManager.gold + card.yield_gold
		
	var mul : int = 0
	for val in _dict.values():
		mul = maxi(mul, val)
	
	GameManager.current_score = GameManager.current_score + (mul * price)
	GameManager.total_score = GameManager.total_score + (mul * price)
	CardManager.played_cards(selected_card)
	CardManager.fill_hand()
	
	GameManager.energy = GameManager.energy - action_list.energy_cost_sell
	action_list.reset_list()

func action_buy(card: Card):
	if card.shop_price > GameManager.gold:
		return
	card.in_shop = false
	GameManager.gold = GameManager.gold - card.shop_price
	CardManager.move_to_hand(card)

#TODO
func action_research():
	pass
	
func coonect_selection(draw_card:Card):
	if !draw_card.selection_change.is_connected(check_selection_condition):
		draw_card.selection_change.connect(check_selection_condition)

func check_selection_condition():
	action_list.update_list(CardManager.get_selected_card())
