extends Node

signal current_turn_change(turn:int)
signal goal_turn_change(turn:int)
signal total_turn_change(turn:int)
signal current_score_change(score:int)
signal goal_score_change(turn:int)
signal total_score_change(score:int)
signal current_energy_change(energy:int)
signal max_energy_change(energy:int)
signal gold_change(gold:int)
signal max_hand_change(max_hand:int)
signal current_discard_energy_change(energy:int)
signal max_discard_energy_change(energy:int)
signal current_shop_refresh_change(gold:int)
signal max_shop_refresh_change(max_hand:int)

var current_turn : int:
	set(value):
		current_turn = value
		current_turn_change.emit(value)

var goal_turn : int:
	set(value):
		total_turn += value - goal_turn
		goal_turn = value
		goal_turn_change.emit(value)
		
var total_turn : int:
	set(value):
		total_turn = value
		total_turn_change.emit(value)
		
var current_score : int:
	set(value):
		current_score = value
		current_score_change.emit(value)
		
var goal_score : int:
	set(value):
		total_score += value - goal_score
		goal_score = value
		goal_score_change.emit(value)
		
var total_score : int:
	set(value):
		total_score = value
		total_score_change.emit(value)

var energy : int:
	set(value):
		energy = value
		current_energy_change.emit(value)
		
var max_energy : int:
	set(value):
		max_energy = value
		max_energy_change.emit(value)
		
var discard_energy : int:
	set(value):
		discard_energy = value
		current_discard_energy_change.emit(value)
		
var max_discard_energy : int:
	set(value):
		max_discard_energy = value
		max_discard_energy_change.emit(value)
				
var shop_refresh : int:
	set(value):
		shop_refresh = value
		current_shop_refresh_change.emit(value)
		
var max_shop_refresh : int:
	set(value):
		max_shop_refresh = value
		max_shop_refresh_change.emit(value)

var gold : int = 10000:
	set(value):
		gold = value
		gold_change.emit(value)
		
var max_hand : int:
	set(value):
		max_hand = value
		max_hand_change.emit(value)
		
var selected_contract: ResourceContract
var constract_selection: Control

var rng: RandomNumberGenerator

var energy_cost_sell: int = 1
var energy_cost_discard: int = 1
var energy_cost_work: int = 1
var energy_cost_research: int = 1

func next_turn():
	current_turn += 1
	energy = max_energy
	discard_energy = max_discard_energy
	shop_refresh = max_shop_refresh
	CardManager.next_turn()
	
func end_turn():
	CardManager.end_turn()
	SellManager.end_turn()
	var turn_limit = selected_contract.turn_limit
	if current_turn == turn_limit:
		if selected_contract.check_finish_contract(current_score):
			current_turn = 0 
			current_score = 0
			selected_contract.get_reward()
			constract_selection.start_select_contract()
		#TODO: Lose game
		else:
			print('fail')
	else:
		next_turn()
	
func select_contract(contract:ResourceContract) -> void:
	selected_contract = contract
	goal_turn = contract.turn_limit
	goal_score = contract.score_goal
	constract_selection.visible = false
	constract_selection.clear_contract() 
	next_turn()

func can_sell(selected_card: Array[Card]) -> bool:
	if selected_card.size() <= 0:
		return false
	if energy < energy_cost_sell:
		return false
	for card in selected_card:
		if card is not ResourceCard:
			return false
	return true

func can_discard(selected_card: Array[Card]) -> bool:
	if selected_card.size() <= 0:
		return false
	if energy < energy_cost_discard:
		return false
	return true

func can_work(selected_card: Array[Card]) -> bool:
	if selected_card.size() <= 0:
		return false
	if energy < energy_cost_work:
		return false
	for card in selected_card:
		if card is not WorkerCard:
			return false
	return true

func can_research(selected_card: Array[Card]) -> bool:
	if selected_card.size() != 3:
		return false
	if energy < energy_cost_research:
		return false
	var _resource: int = 0
	var _worker: int = 0
	for _card: Card in selected_card:
		if _card is ResourceCard:
			_resource += 1
		elif _card is WorkerCard:
			_worker += 1
	return (_resource == 2) and (_worker == 1)

func can_activate(selected_card: Array[Card]) -> bool:
	if selected_card.size() != 1:
		return false
	return selected_card[0] is InstantCard
