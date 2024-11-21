extends Node

signal action_done

var action_list: ActionListController

## Section: Actions
func action_work(business: BusinessCard):
	var selected_card = CardManager.get_selected_card()
	if !GameManager.can_work(selected_card):
		return
		
	# TODO: Change to check rate
	for card in selected_card:
		if card.is_selected:
			var _res_id = business.gather_resource()
			var new_card = CardManager.add_card_to_deck(_res_id)
			CardManager.discard(new_card)
	CardManager.discards(selected_card)
	CardManager.fill_hand()
	
	GameManager.energy = GameManager.energy - GameManager.energy_cost_work
	action_list.reset_list()
	
	emit_signal("action_done")
	
func action_discard():
	CardManager.discards(CardManager.get_selected_card())
	CardManager.fill_hand()
	
	GameManager.energy = GameManager.energy - GameManager.energy_cost_discard
	action_list.reset_list()
	
	emit_signal("action_done")

func action_sell():
	var selected_card: Array[Card] = CardManager.get_selected_card()

	SellManager.sell(selected_card)
	CardManager.played_cards(selected_card)
	CardManager.fill_hand()
	
	GameManager.energy = GameManager.energy - GameManager.energy_cost_sell
	action_list.reset_list()
	
	emit_signal("action_done")

func action_buy(card: Card):
	if card.shop_price > GameManager.gold:
		return
	
	GameManager.gold = GameManager.gold - card.shop_price
	card.in_shop = false
	
	if card is BusinessCard:
		CardManager.field.add_exists(card)
	else:
		CardManager.hand.add_exists(card)
	
	emit_signal("action_done")

func _get_research_reward_by_priority(_data: ResourceCardData, _priority: int) -> Array[ResearchReward]:
	var _resp: Array[ResearchReward] = []
	for _reward: ResearchReward in _data.research_yield:
		if _reward.priority == _priority:
			_resp.append(_reward)
	return _resp

func _get_valid_research_reward_priority(_data: ResourceCardData, _another_resource_id: int) -> int:
	var _priority: int = 0
	while true:
		var _res_rewards = _get_research_reward_by_priority(_data, _priority)
		var valid = false
		for _res in _res_rewards:
			if _res.can_activate(_another_resource_id):
				valid = true
		# TODO: make sure priority always not overflow
		if valid or _priority >= 3:
			break
		_priority += 1
	return _priority

func action_research():
	var selected_card = CardManager.get_selected_card()
	if !GameManager.can_research(selected_card):
		return
	
	var _res_card_data: Array[ResourceCardData]
	for card: Card in selected_card:
		if card is ResourceCard:
			_res_card_data.append(card.card_data)
			
	var _priority_0 = _get_valid_research_reward_priority(_res_card_data[0], _res_card_data[1].card_id)
	var _priority_1 = _get_valid_research_reward_priority(_res_card_data[1], _res_card_data[0].card_id)
	
	var _reward: Array[ResearchReward] = _get_research_reward_by_priority(_res_card_data[0], _priority_0) + _get_research_reward_by_priority(_res_card_data[1], _priority_1)
	var _w_arr: Array[float]
	for _r in _reward:
		_w_arr.append(_r.chance)
	
	var _w = PackedFloat32Array(_w_arr)
	#print(_reward[GameManager.rng.rand_weighted(_w)].chance)
	emit_signal("action_done")
	
	
func action_activate() -> void:
	var selected_card: Array[Card] = CardManager.get_selected_card()
	selected_card[0].activate()
	CardManager.discards(selected_card)
	CardManager.fill_hand()
	
func connect_selection(draw_card: Card):
	if !draw_card.selection_change.is_connected(check_selection_condition):
		draw_card.selection_change.connect(check_selection_condition)

func check_selection_condition():
	if action_list:
		action_list.update_list(CardManager.get_selected_card())
