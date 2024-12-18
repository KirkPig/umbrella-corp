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
		current_contract_change.emit(value)

var max_contract:int:
	set(value):
		max_contract = value
		max_contract_change.emit(value)

var most_score_contract:int = 0:
	set(value):
		if value > most_score_contract:
			most_score_contract = value

# Level user interface
var scoreboard: Control
var phone_canvas: UIPhone

var tutorial_screen: UITutorial

var selected_contract: ContractData
var contract_selection: UIContractSelection
var selected_contract_ui: UIContract
var contract_reward: UIContractReward:
	set(value):
		value.show_contract_reward_done.connect(_finish_complete_contract)
		contract_reward = value

var rng: RandomNumberGenerator

var energy_cost_sell: int = 1
var energy_cost_discard: int = 1
var energy_cost_work: int = 1
var energy_cost_research: int = 1

var game_speed: float = 1

# Color code
var wallet_color: Color = Color("000000")
var worker_color: Color = Color("B2DEFF")
var resource_color: Color = Color("FBFEDF")
var business_color: Color = Color("B8FFAD")
var instant_color: Color = Color("FFBEBE")
var upgrade_color: Color = Color("C1A1FF")

var is_tutorial: bool = false

func start_tutorial():
	is_tutorial = true
	hide_level_ui()
	tutorial_screen.show()
	tutorial_screen.play_start_up()
	await tutorial_screen.start_up_finished
	contract_selection.show()
	contract_selection.clear_contract()
	contract_selection.fill_tutorial_contract()
	contract_selection.start_select_contract()
	await contract_selection.select_contract_ready
	tutorial_screen.play_contract()
	await tutorial_screen.start_up_finished

# TODO: transition show and hide each ui component
func show_level_ui():
	scoreboard.show()
	phone_canvas.show()
	phone_canvas.start_up()
	CardManager.business_field.show()

func hide_level_ui():
	scoreboard.hide()
	phone_canvas.hide()
	CardManager.business_field.hide()

func start_select_contract() -> void:
	hide_level_ui()
	contract_selection.show()
	contract_selection.clear_contract()
	contract_selection.fill_random_contract(3)
	contract_selection.start_select_contract()

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
			if current_contract >= max_contract:
				game_end.emit(true)
			complete_contract()
		else:
			game_end.emit(false)
	else:
		phone_canvas.play_sleeping()
		await phone_canvas.play_sleeping_done
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
	
	contract_selection.clear_contract()
	contract_selection.hide()
	await get_tree().create_timer(0.2 / game_speed).timeout
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(_contract, "position", Vector2(10, 10), 0.8 / game_speed)
	await get_tree().create_timer(0.6 / game_speed).timeout
	current_contract += 1
	selected_contract_ui = _contract
	if is_tutorial:
		start_tutorial_contract()
	else:
		start_contract()

func start_contract() -> void:
	show_level_ui()
	next_turn()

func start_tutorial_contract() -> void:
	tutorial_screen.play_phone_give()
	await tutorial_screen.phone_give_finished
	phone_canvas.show()
	phone_canvas.start_up()
	await phone_canvas.start_up_done
	tutorial_screen.play_phone_flow()
	await tutorial_screen.play_phone_flow_finished

func complete_contract() -> void:
	if current_score > most_score_contract:
		most_score_contract = current_score
	current_turn = 0 
	current_score = 0
	selected_contract_ui.queue_free() # TODO: complete contract transition
	
	contract_reward.clear_reward()
	hide_level_ui()
	contract_reward.show()
	selected_contract.get_reward()

func _finish_complete_contract() -> void:
	contract_reward.hide()
	start_select_contract()

func can_sell(selected_card: Array[Card]) -> bool:
	if selected_card.size() <= 0:
		return false
	if energy < energy_cost_sell:
		return false
	for card in selected_card:
		if card is not ResourceCard:
			return false
	return true

func can_sell_business(_business: UIBusiness) -> bool:
	if ActionManager.is_change_resource: return false
	if ActionManager.is_currently_on_action: return false
	return true


func can_add_components(selected_card: Array[Card], resource_components: Array[ResourceComponentItemData]) -> bool:
	if ActionManager.is_currently_on_action: return false
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

func can_business_change_resource(_business: UIBusiness) -> bool:
	if ActionManager.is_change_resource: return false
	if ActionManager.is_currently_on_action: return false
	if GameManager.gold < _business.change_resource_price: return false
	var _data: BusinessCardData = _business.business_card_data
	return _data.resource_yield_list.size() > 1

func can_discard(selected_card: Array[Card]) -> bool:
	if ActionManager.is_currently_on_action: return false
	if selected_card.size() <= 0:
		return false
	if discard_energy <= 0:
		return false
	return true

func can_work(selected_card: Array[Card]) -> bool:
	if ActionManager.is_currently_on_action: return false
	if selected_card.size() <= 0:
		return false
	if energy < energy_cost_work:
		return false
	for card in selected_card:
		if card is not WorkerCard:
			return false
	return true

func can_research(selected_card: Array[Card]) -> bool:
	if ActionManager.is_currently_on_action: return false
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
	if ActionManager.is_currently_on_action: return false
	var cards_in_hand = CardManager.get_all_card(CardManager.ECardLocation.hand)
	for card in cards_in_hand:
		if card is InstantCard:
			card.set_can_activate(false)
		
	if selected_card.size() != 1:
		return false
		
	if selected_card[0] is InstantCard:
		selected_card[0].set_can_activate(true)
	return selected_card[0] is InstantCard
