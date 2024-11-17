extends Node

var action_list: ActionListController

## Section: Actions
func action_work(business: BusinessCard):
	var selected_card = CardManager.get_selected_card()
	if !GameManager.can_work(selected_card):
		return
		
	# TODO: Chnage to check rate
	for card in selected_card:
		if card.is_selected:
			var data = business.gather_resource()
			var new_card = CardManager.add_card_to_deck(data)
			CardManager.discard(new_card)
	CardManager.discards(selected_card)
	CardManager.fill_hand()
	
	GameManager.energy = GameManager.energy - GameManager.energy_cost_work
	action_list.reset_list()
	
func action_discard():
	CardManager.discards(CardManager.get_selected_card())
	CardManager.fill_hand()
	
	GameManager.energy = GameManager.energy - GameManager.energy_cost_discard
	action_list.reset_list()

func action_sell():
	var selected_card: Array[Card] = CardManager.get_selected_card()

	SellManager.sell(selected_card)
	CardManager.played_cards(selected_card)
	CardManager.fill_hand()
	
	GameManager.energy = GameManager.energy - GameManager.energy_cost_sell
	action_list.reset_list()

func action_buy(card: Card):
	if card.shop_price > GameManager.gold:
		return
	card.in_shop = false
	GameManager.gold = GameManager.gold - card.shop_price
	CardManager.move_to_hand(card)

# TODO: research recipe
func action_research():
	pass
	
func connect_selection(draw_card: Card):
	if !draw_card.selection_change.is_connected(check_selection_condition):
		draw_card.selection_change.connect(check_selection_condition)

func check_selection_condition():
	if action_list:
		action_list.update_list(CardManager.get_selected_card())
