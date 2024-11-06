extends Control
class_name GameManager

@export var start_energy : int = 3
@export var max_hand : int = 5
@export var contract_turn : int = 3
@export var target_score : int = 500

@onready var field = $Field
@onready var hand = $Hand
@onready var shop = $Shop

@onready var deck = $Deck
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
	action_list.btn_sell_pressed.connect(action_sell)
	action_list.btn_discard_pressed.connect(action_discard)
	action_list.btn_end_pressed.connect(end_turn)
	start_game()

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
	
func create_worker_card() -> WorkerCard:
	var card : WorkerCard = worker_card.instantiate()
	card.is_buy.connect(action_buy)
	return card

func create_business_card() -> BusinessCard:
	var card : BusinessCard = business_card.instantiate()
	card.is_buy.connect(action_buy)
	card.selected_work.connect(action_work)
	return card

func added_start_deck():
	for i in 10:
		var card = create_worker_card()
		deck.add_child(card)

func added_business_field():
	var card : BusinessCard = create_business_card()
	field.add_child(card)

func start_new_turn():
	energy = max_energy
	reset_deck()
	fill_hand()
	reset_shop()

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

func reset_hand():
	for card in hand.get_children():
		discard(card)

func reset_shop():
	for card in shop.get_children():
		shop.remove_child(card)
		if is_instance_valid(card):
			card.queue_free()
	for i in 3:
		var card = create_worker_card()
		shop.add_child(card)
		card.in_shop = true

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
		
func free_played_card():
	for card in played.get_children():
		played.remove_child(card)
		if is_instance_valid(card):
			card.queue_free()

func end_turn():
	reset_hand()
	free_played_card()
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

# Section: Actions
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
	action_list.reset_list()
	
func action_discard():
	discards(get_selected_card())
	fill_hand()
	
	energy = energy - action_list.energy_cost_discard
	action_list.reset_list()

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
	action_list.reset_list()

func action_buy(card: Card):
	if card.shop_price > gold:
		return
	card.in_shop = false
	gold = gold - card.shop_price
	card.reparent(hand)

func action_research():
	pass
	
