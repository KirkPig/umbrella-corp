extends Node

var turn : int
var score : int
var energy : int
var gold : int

@export var start_energy : int = 1
@export var max_hand : int = 5
@export var contract_turn : int = 3
@export var target_score : int = 500

var card_list = {}

@onready var deck = $"../Deck"
@onready var field = $"../Field"
@onready var hand = $"../Hand"
@onready var discarded = $"../Discard"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	turn = 0
	score = 0
	gold = 0
	added_new_deck()
	start_new_turn()

func added_new_deck():
	for i in 10:
		var card = WorkerCard.new("Worker", "Description")
		deck.add_child(card)

func start_new_turn():
	energy = start_energy
	reset_deck()
	fill_hand()

func reset_deck():
	for card in discarded.get_children():
		card.reparent(deck)

func fill_hand():
	while true:
		var hand_cards = hand.get_children()
		if hand_cards.size() >= max_hand:
			break
			
		var deck_cards = deck.get_children()
		if deck_cards.size() <= 0:
			break
		var draw_card = deck_cards[randi() % deck_cards.size()]
		draw_card.reparent(hand)
				

func get_selected_card() -> Array[Card]:
	var selected_card : Array[Card]
	for card in hand.get_children():
		if card is Card and card.is_selected:
			selected_card.append(card)
	return selected_card

func discard(cards: Array[Card]):
	for card in cards:
		card.reparent(discarded)
	pass

# Actions
func action_work():
	var selected_card = get_selected_card()
	pass
	
func action_discard():
	discard(get_selected_card())

func sell():
	pass

func buy():
	pass

func research():
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
