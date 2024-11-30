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
signal max_shop_refresh_change(max_refresh:int)
signal current_contract_change(max_contract:int)
signal max_contract_change(max_contract:int)

signal game_end(win:bool)

var current_turn : int:
	set(value):
		total_turn += value - current_turn
		current_turn = value
		current_turn_change.emit(value)

var goal_turn : int:
	set(value):
		goal_turn = value
		goal_turn_change.emit(value)
		
var total_turn : int:
	set(value):
		total_turn = value
		total_turn_change.emit(value)
		
var current_score : int:
	set(value):
		total_score += value - current_score
		current_score = value
		current_score_change.emit(value)
		
var goal_score : int:
	set(value):
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

var current_contract:int = 0: 
	set(value):
		current_contract = value
		if current_contract == max_contract:
			game_end.emit(true)
		current_contract_change.emit(value)

var max_contract:int:
	set(value):
		max_contract = value
		max_contract_change.emit(value)

var most_score_contract:int = 0:
	set(value):
		if value > most_score_contract:
			most_score_contract = value
		
var selected_contract: ContractData
var contract_selection: UIContractSelection

var rng: RandomNumberGenerator

var energy_cost_sell: int = 1
var energy_cost_discard: int = 1
var energy_cost_work: int = 1
var energy_cost_research: int = 1

var game_speed: float = 1

func start_select_contract() -> void:
	contract_selection.show()
	contract_selection.clear_contract()
	for i in 3:
		var _data = ContractManager.get_random_contract_data()
		contract_selection.add_contract(_data)

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
			if current_score > most_score_contract:
				most_score_contract = current_score
			current_turn = 0 
			current_score = 0
			selected_contract.get_reward()
			start_select_contract()
		else:
			game_end.emit(false)
	else:
		next_turn()
	
func select_contract(_contract: UIContract) -> void:
	var _level = CardManager.hand.get_parent()
	selected_contract = _contract.data
	goal_turn = selected_contract.turn_limit
	goal_score = selected_contract.score_goal
	
	_contract.is_selected = false
	_contract.is_disable_selection = true
	var _old_position = _contract.global_position
	_contract.reparent(_level)
	_contract.global_position = _old_position
	
	contract_selection.hide()
	await get_tree().create_timer(0.1 / game_speed).timeout
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(_contract, "position", Vector2(10, 10), 0.4 / game_speed)
	await tween.finished
	
	current_contract += 1
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

func can_add_components(selected_card: Array[Card], resource_components: Array[ResourceComponentItemData]) -> bool:
	var _li: Array[int] = []
	for _j in resource_components:
		_li.append(_j.resource_id)
	if selected_card.size() <= 0:
		return false
	if energy < energy_cost_sell:
		return false
	for card in selected_card:
		if card is not ResourceCard:
			return false
		if card.card_id not in _li:
			return false
	return true

func can_business_change_resource(business_card_id: int) -> bool:
	var _data: BusinessCardData = CardManager.card_dict[business_card_id]
	return _data.resource_yield_list.size() > 1

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
