extends Node

@export var start_energy : int = 1
@export var max_hand : int = 5
@export var contract_turn : int = 3
@export var target_score : int = 500

@onready var deck = $"../Deck"
@onready var field = $"../Field"
@onready var hand = $"../Hand"
@onready var discarded = $"../Discard"
@onready var action_list = $"../ActionList"

@onready var worker_card = preload("res://Card/Presets/S_Worker.tscn")
@onready var business_card = preload("res://Card/Presets/S_Business.tscn")

var turn : int
var score : int
var energy : int
var gold : int

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
	turn = 0
	score = 0
	gold = 0
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
	energy = start_energy
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
	action_list.update_list(get_selected_card())

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

func discard(card: Card):
	card.reparent(discarded)
	if card.selection_change.is_connected(check_selection_condition):
		card.selection_change.disconnect(check_selection_condition)

func discards(cards: Array[Card]):
	for card in cards:
		discard(card)

# Actions
func action_work(business: BusinessCard):
	var selected_card = get_selected_card()
	for card in selected_card:
		if card.is_selected:
			var _res = business.gather_resource()
			discarded.add_child(_res)
	discards(selected_card)
	fill_hand()
	
func action_discard():
	discards(get_selected_card())
	fill_hand()

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
	pass
	
	var mul : int = max(_dict.values())
	

func action_buy():
	pass

func action_research():
	pass

func end_turn():
	turn = turn + 1
	if turn >= contract_turn:
		check_win_condition()
	else:
		start_new_turn()

func check_win_condition():
	if score >= target_score:
		print("You win")
	else: 
		print("You lose")
