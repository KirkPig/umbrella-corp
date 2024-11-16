extends Node

@onready var template_worker_card = preload("res://Card/Presets/S_Worker.tscn")
@onready var template_business_card = preload("res://Card/Presets/S_Business.tscn")
@onready var template_resource_card = preload("res://Card/Presets/S_Resource.tscn")

var field: Control
var hand: HandController
var shop: ShopController
var deck: Control
var discarded: Control
var played: Control

var card_pool: Array[CardData]

func create_card(data: CardData) -> Card:
	if data is WorkerCardData:
		return create_worker_card(data)
	elif data is BusinessCardData:
		return create_business_card(data)
	elif data is ResourceCardData:
		return create_resource_card(data)
	else:
		return

func create_worker_card(data: WorkerCardData) -> WorkerCard:
	var card : WorkerCard = template_worker_card.instantiate()
	card.is_buy.connect(ActionManager.action_buy)
	return card

func create_business_card(data: BusinessCardData) -> BusinessCard:
	var card : BusinessCard = template_business_card.instantiate()
	card.is_buy.connect(ActionManager.action_buy)
	card.selected_work.connect(ActionManager.action_work)
	return card

func create_resource_card(data: ResourceCardData) -> ResourceCard:
	var card : ResourceCard = template_resource_card.instantiate()
	card.is_buy.connect(ActionManager.action_buy)
	return card

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func add_card_to_deck(data: CardData) -> Card:
	var card = create_card(data)
	if !card:
		return
	deck.add_child(card)
	card.set_data(data)
	
	return card

func add_card_to_hand(data: CardData) -> Card:
	var card = create_card(data)
	if !card:
		return
	hand.add_child(card)
	card.set_data(data)
	ActionManager.connect_selection(card)
	hand.update_in_hand()
	return card
	
func add_card_to_shop(data: CardData) -> Card:
	var card = create_card(data)
	if !card:
		return
	shop.add_child(card)
	card.set_data(data)
	ActionManager.connect_selection(card)
	card.in_shop = true
	shop.update_in_shop()
	return card

func added_business_field(data : BusinessCardData):
	var card : BusinessCard = create_business_card(data)
	field.add_child(card)
	card.set_data(data)

func reset_shop():
	for card in shop.get_children():
		shop.remove_child(card)
		if is_instance_valid(card):
			card.queue_free()
	for i in 3:
		add_card_to_shop(card_pool[GameManager.rng.randi() % card_pool.size()])

func draw() -> bool:
	var deck_cards = deck.get_children()
	if deck_cards.size() <= 0:
		return false
	var draw_card: Card = deck_cards[GameManager.rng.randi() % deck_cards.size()]
	draw_card.reparent(hand)
	ActionManager.connect_selection(draw_card)
	hand.update_in_hand()
	return true

func fill_hand():
	while true:
		var hand_cards = hand.get_children()
		if hand_cards.size() >= GameManager.max_hand : break
		if !draw(): break

func reset_hand():
	for card in hand.get_children():
		discard(card)

func reset_deck():
	for card in discarded.get_children():
		card.reparent(deck)

func move_to_hand(node: Card):
	node.reparent(hand)
	hand.update_in_hand()

func get_selected_card() -> Array[Card]:
	var selected_card : Array[Card]
	for card in hand.get_children():
		if card is Card and card.is_selected:
			selected_card.append(card)
	return selected_card
#
func played_card(card: Card):
	card.is_selected = false
	card.reparent(played)
	ActionManager.connect_selection(card)
#
func played_cards(cards: Array[Card]):
	for card in cards:
		played_card(card)
#
func discard(card: Card):
	card.is_selected = false
	card.reparent(discarded)
	ActionManager.connect_selection(card)
#
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

func next_turn():
	reset_deck()
	fill_hand()
	reset_shop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
