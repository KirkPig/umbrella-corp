extends Control
class_name GameManager

@export var start_energy : int = 1
@export var max_hand : int = 5
@export var contract_turn : int = 3
@export var target_score : int = 500

@onready var deck = $Deck
@onready var field = $Field
@onready var hand = $Hand
@onready var discarded = $Discard
@onready var played = $Played

@onready var action_list = $ActionList
@onready var status_bar = $StatusBar

@onready var worker_card = preload("res://Card/Presets/S_Worker.tscn")
@onready var business_card = preload("res://Card/Presets/S_Business.tscn")

var turn : int:
	set(value):
		turn = value
		status_bar.turn = value
var score : int:
	set(value):
		score = value
		status_bar.score = value
var energy : int:
	set(value):
		energy = value
		status_bar.energy = value
var max_energy : int:
	set(value):
		max_energy = value
		status_bar.max_energy = value
var gold : int:
	set(value):
		gold = value
		status_bar.gold = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game()
	action_list.btn_sell_pressed.connect(action_sell)
	action_list.btn_discard_pressed.connect(action_discard)
	action_list.btn_end_pressed.connect(end_turn)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	turn = 1
	score = 0
	gold = 0
	max_energy = start_energy
	added_start_deck()
	added_business_field()
	start_new_turn()

func added_start_deck():
	for i in 10:
		var card = worker_card.instantiate()
		deck.add_child(card)

func added_business_field():
	var card : BusinessCard = business_card.instantiate()
	field.add_child(card)
	card.selected_work.connect(action_work)

func start_new_turn():
	energy = max_energy
	reset_deck()
	fill_hand()

func reset_deck():
	for card in discarded.get_children():
		card.reparent(deck)

func draw() -> bool:
	var deck_cards = deck.get_children()
	if deck_cards.size() <= 0:
		return false
	var draw_card: Card = deck_cards[randi() % deck_cards.size()]
	draw_card.reparent(hand)
	if !draw_card.selection_change.is_connected(check_selection_condition):
		draw_card.selection_change.connect(check_selection_condition)
	return true

func check_selection_condition():
	action_list.update_list(get_selected_card(), energy)

func fill_hand():
	while true:
		var hand_cards = hand.get_children()
		if hand_cards.size() >= max_hand : break
		if !draw(): break

func get_selected_card() -> Array[Card]:
	var selected_card : Array[Card]
	for card in hand.get_children():
		if card is Card and card.is_selected:
			selected_card.append(card)
	return selected_card
	

func played_card(card: Card):
	card.is_selected = false
	card.reparent(played)
	if card.selection_change.is_connected(check_selection_condition):
		card.selection_change.disconnect(check_selection_condition)

func played_cards(cards: Array[Card]):
	for card in cards:
		played_card(card)

func discard(card: Card):
	card.is_selected = false
	card.reparent(discarded)
	if card.selection_change.is_connected(check_selection_condition):
		card.selection_change.disconnect(check_selection_condition)

func discards(cards: Array[Card]):
	for card in cards:
		discard(card)

# Actions
func action_work(business: BusinessCard):
	var selected_card = get_selected_card()
	
	# TODO: More on can not work if energy is not enough
	if !action_list.can_work(selected_card, energy):
		return
		
	for card in selected_card:
		if card.is_selected:
			var _res = business.gather_resource()
			discarded.add_child(_res)
	discards(selected_card)
	fill_hand()
	
	energy = energy - action_list.energy_cost_work
	
func action_discard():
	discards(get_selected_card())
	fill_hand()
	
	energy = energy - action_list.energy_cost_discard

func action_sell():
	var selected_card: Array[Card] = get_selected_card()
	var _dict : Dictionary = {}
	var price = 0
	for card : ResourceCard in selected_card:
		if card.resource_id in _dict:
			_dict[card.resource_id] += 1
		else:
			_dict[card.resource_id] = 1
		price = price + card.point
		gold = gold + card.gold
		
	var mul : int = 0
	for val in _dict.values():
		mul = maxi(mul, val)
	
	score = score + (mul * price)
	played_cards(selected_card)
	fill_hand()
	
	energy = energy - action_list.energy_cost_sell

func action_buy():
	pass

func action_research():
	pass

func end_turn():
	if turn >= contract_turn:
		check_win_condition()
	else:
		turn = turn + 1
		start_new_turn()

func check_win_condition():
	if score >= target_score:
		print("You win")
	else: 
		print("You lose")
