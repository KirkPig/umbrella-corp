extends Node

signal action_done
signal reset_action_list

var action_list: ActionListController
var playing_field: PlayingFieldController:
	set(value):
		value.selected_resource_done.connect(_finish_action_change_resource)
		playing_field = value
var research_reward_summary: UIResearchReward:
	set(value):
		value.show_research_reward_done.connect(_finish_action_research)
		research_reward_summary = value

var is_change_resource: bool = false
var is_currently_on_action: bool = false
var _selected_business_ui: UIBusiness

var flash_screen: UIFlashColor

func _ready() -> void:
	reset_action_list.connect(_update_action_list)
	action_done.connect(_action_done_reset)

func _update_action_list():
	action_list.reset_list()
	CardManager.business_field.update_child_ui()

func _action_done_reset():
	is_currently_on_action = false
	_update_action_list()

## Section: Actions
func action_work(business: UIBusiness):
	var selected_card = CardManager.get_selected_card()
	if !GameManager.can_work(selected_card):
		return
	is_currently_on_action = true
	_update_action_list()
	# TODO: Change to check rate
	for _card: WorkerCard in selected_card:
		_card.card_play.connect(business.yield_labor)
	playing_field.playing_cards(selected_card, Vector2(-300, 500), false)
	CardManager.hand.update_position()
	await playing_field.playing_cards_done
	for _card: WorkerCard in selected_card:
		_card.card_play.disconnect(business.yield_labor)

	CardManager.discards(selected_card)
	CardManager.fill_hand()
	
	GameManager.energy -=  GameManager.energy_cost_work
	action_done.emit()

func action_add_component(business: UIBusiness):
	var selected_card = CardManager.get_selected_card()
	if !GameManager.can_add_components(selected_card, business.current_yield.components):
		return
	is_currently_on_action = true
	_update_action_list()
	for _card: ResourceCard in selected_card:
		_card.card_play.connect(business.added_component)
	playing_field.playing_cards(selected_card, Vector2(-300, 500), false)
	CardManager.hand.update_position()
	await playing_field.playing_cards_done
	for _card: ResourceCard in selected_card:
		_card.card_play.disconnect(business.added_component)
	CardManager.played_cards(selected_card)
	CardManager.fill_hand()
	
	GameManager.energy -=  GameManager.energy_cost_work
	action_done.emit()
	

func action_discard():
	var selected_card = CardManager.get_selected_card()
	is_currently_on_action = true
	_update_action_list()
	CardManager.hand.start_discard_transition()
	await CardManager.hand.discard_transition_done
	CardManager.discards(selected_card)
	CardManager.fill_hand()
	
	GameManager.discard_energy -= GameManager.energy_cost_discard
	action_done.emit()

func action_sell():
	var selected_card: Array[Card] = CardManager.get_selected_card()
	
	is_currently_on_action = true
	_update_action_list()
	# TODO: show each price and demand in phone screen
	playing_field.playing_cards(selected_card, Vector2(-300, playing_field.global_position.y), false)
	CardManager.hand.update_position()
	await playing_field.playing_cards_done

	SellManager.sell(selected_card)
	CardManager.played_cards(selected_card)
	CardManager.fill_hand()
	
	GameManager.energy = GameManager.energy - GameManager.energy_cost_sell
	action_done.emit()

func action_sell_business(_ui: UIBusiness):
	is_currently_on_action = true
	_update_action_list()
	# TODO: check on the sell business
	GameManager.gold += _ui.sell_price
	CardManager.business_field.remove_child(_ui)
	if is_instance_valid(_ui):
		_ui.queue_free()
	action_done.emit()

func action_buy(card: Card)-> bool:
	if card.shop_price > GameManager.gold:
		return false
	is_currently_on_action = true
	GameManager.gold = GameManager.gold - card.shop_price
	card.in_shop = false
	
	if card is BusinessCard:
		CardManager.add_card_to_business_field(card.card_id,card.current_yield_id)
		card.queue_free() # TODO: make animation buying
	elif card is UpgradeCard:
		card.card_data.played()
		card.queue_free() # TODO: make animation buying
	else:
		CardManager.hand.add_exists(card) # TODO: make animation buying
		
	CardManager.shop.reset_shop()
	action_done.emit()
	
	return true

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
		if valid or _priority >= 3:
			break
		_priority += 1
	return _priority

func action_research():
	var selected_card = CardManager.get_selected_card()
	if !GameManager.can_research(selected_card):
		return
	
	is_currently_on_action = true
	_update_action_list()
	var _worker: WorkerCard
	var _res_card_data: Array[ResourceCardData]
	for card: Card in selected_card:
		if card is WorkerCard:
			_worker = card
		if card is ResourceCard:
			_res_card_data.append(card.card_data)
			
	var _priority_0 = _get_valid_research_reward_priority(_res_card_data[0], _res_card_data[1].card_id)
	var _priority_1 = _get_valid_research_reward_priority(_res_card_data[1], _res_card_data[0].card_id)
	
	var _reward: Array[ResearchReward] = _get_research_reward_by_priority(_res_card_data[0], _priority_0) + _get_research_reward_by_priority(_res_card_data[1], _priority_1)
	var _w_arr: Array[float]
	for _r in _reward:
		_w_arr.append(_r.chance)
	var _w = PackedFloat32Array(_w_arr)
	var _rand_r = _reward[GameManager.rng.rand_weighted(_w)]
	
	# Calculate chance that _worker is not destroy
	var _k = [false, true]
	var _n_w_arr = [_worker.card_data.research_chance_destroy, 100 - _worker.card_data.research_chance_destroy]
	var _n_w = PackedFloat32Array(_n_w_arr)
	if _k[GameManager.rng.rand_weighted(_n_w)]:
		CardManager.discard(_worker)
	
	research_reward_summary.clear_reward()
	if _rand_r is ResearchRewardBonus:
		_rand_r.reward_bonus_gold_result.connect(research_reward_summary.add_gold_reward)
		_rand_r.reward_bonus_card_result.connect(research_reward_summary.add_card_reward)
	if _rand_r is ResearchRewardUnlockCard:
		_rand_r.reward_bonus_unlock_card_result.connect(research_reward_summary.add_unlock_card)
	if _rand_r is ResearchRewardUnlockResource:
		_rand_r.reward_bonus_unlock_business_result.connect(research_reward_summary.add_unlock_business)
		_rand_r.reward_bonus_unlock_resource_result.connect(research_reward_summary.add_unlock_resource)
	
	playing_field.playing_research(selected_card)
	CardManager.hand.update_position()
	await playing_field.playing_research_done
	flash_screen.show()
	var tween: Tween = create_tween()
	tween.tween_property(flash_screen, "texture_amount", 1, 0.2)
	await tween.finished
	tween = create_tween()
	tween.tween_property(flash_screen, "texture_amount", 0, 0.05)
	CardManager.played_cards(selected_card)
	for _c: Card in selected_card:
		_c.texture_flash_rect.hide()
	GameManager.energy -=  GameManager.energy_cost_work
	_rand_r.activate() # Activate reward
	
	research_reward_summary.show_research_reward_done.connect(_finish_action_research)
	research_reward_summary.show()
	await tween.finished
	action_list.research_done_audio_stream_player.play()
	flash_screen.hide()
	
func _finish_action_research():
	research_reward_summary.hide()
	CardManager.fill_hand()
	action_done.emit()
	
func action_activate() -> void:
	var selected_card: Array[Card] = CardManager.get_selected_card()
	
	is_currently_on_action = true
	_update_action_list()
	selected_card[0].activate()
	CardManager.discards(selected_card)
	
	if selected_card[0].card_data.destroy_self:
		if GameManager.rng.randi() % 100 < selected_card[0].card_data.destroy_chance:
			selected_card[0].queue_free()
	
	CardManager.fill_hand()
	action_done.emit()

func action_change_resource(_business: UIBusiness) -> void:
	if !GameManager.can_business_change_resource(_business): return
	if is_change_resource: return
	
	is_currently_on_action = true
	_update_action_list()
	var _li = _business.business_card_data.resource_yield_list
	playing_field.playing_change_resource(_li)
	GameManager.gold -= _business.change_resource_price
	is_change_resource = true
	_selected_business_ui = _business
	CardManager.business_field.update_child_ui()

func _finish_action_change_resource(_card: Card):
	playing_field.finish_playing_change_resource(Vector2(-300, 500))
	await playing_field.playing_change_resource_done
	_selected_business_ui.current_yield = CardManager.card_dict[_card.card_id]
	is_change_resource = false
	action_done.emit()

func connect_selection(draw_card: Card):
	if !draw_card.selection_change.is_connected(check_selection_condition):
		draw_card.selection_change.connect(check_selection_condition)

func check_selection_condition():
	if action_list:
		action_list.update_list(CardManager.get_selected_card())
