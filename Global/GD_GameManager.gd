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
		
var gold : int:
	set(value):
		gold = value
		gold_change.emit(value)
		
var max_hand : int:
	set(value):
		max_hand = value
		max_hand_change.emit(value)
		
var selected_contract: ResourceContract
var constract_selection: Control

func next_turn():
	current_turn += 1
	energy = max_energy
	CardManager.next_turn()
	
func end_turn():
	CardManager.end_turn()
	SellManager.end_turn()
	var turn_limit = selected_contract.turn_limit
	if current_turn == turn_limit:
		if selected_contract.check_finish_contract(current_score):
			current_turn = 0 
			current_score = 0
			print("win")
		#TODO: Lose game
		else:
			print('fail')
	else:
		next_turn()

func start_select_contract():
	constract_selection.start_select_contract()
	
func select_contract(contract:ResourceContract) -> void:
	selected_contract = contract
	goal_turn = contract.turn_limit
	goal_score = contract.score_goal
	constract_selection.visible = false
	constract_selection.clear_contract() 
	GameManager.next_turn()
