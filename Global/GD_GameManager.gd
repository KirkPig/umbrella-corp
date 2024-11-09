extends Node

signal current_turn_change(turn:int)
signal total_turn_change(turn:int)
signal current_score_change(score:int)
signal total_score_change(score:int)
signal current_energy_change(energy:int)
signal max_energy_change(energy:int)
signal gold_change(gold:int)
signal max_hand_change(max_hand:int)

var current_turn : int:
	set(value):
		current_turn = value
		current_turn_change.emit(value)

var total_turn : int:
	set(value):
		total_turn = value
		total_turn_change.emit(value)
		
var current_score : int:
	set(value):
		current_score = value
		current_score_change.emit(value)
		
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
		
var selected_contract: Contract

func next_turn():
	var turn_limit = selected_contract.turn_limit
	if current_turn + 1 == turn_limit:
		current_turn = 0 if selected_contract.check_finish_contract() else current_turn + 1
	total_turn += 1
	
#TODO: make contract to select
func select_contract():
	pass
