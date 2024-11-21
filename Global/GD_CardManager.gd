extends Node

@onready var template_worker_card = preload("res://Card/Presets/S_Worker.tscn")
@onready var template_business_card = preload("res://Card/Presets/S_Business.tscn")
@onready var template_resource_card = preload("res://Card/Presets/S_Resource.tscn")

enum ECardLocation {
	hand,
	shop,
	field,
	deck,
	discarded
}

var card_dict: Dictionary = {}

var field: Control
var hand: HandController
var shop: ShopController
var deck: Control
var discarded: Control
var played: Control

var card_pool: Array[int]

func _ready() -> void:
	load_cards("res://Resource/Card/Business/")
	load_cards("res://Resource/Card/Resource/")
	load_cards("res://Resource/Card/Worker/")

func load_cards(_path: String) -> void:
	var _card_res = DirAccess.get_files_at(_path)
	for _files in _card_res:
		var data: CardData = load(_path + _files)
		card_dict[data.card_id] = data

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

func add_card_to_deck(data: CardData) -> Card:
	var card = create_card(data)
	if !card:
		return
	deck.add_child(card)
	card.card_data = data
	
	return card

func add_card_to_hand(data: CardData) -> Card:
	var card = create_card(data)
	if !card:
		return
	hand.add_child(card)
	card.card_data = data
	ActionManager.connect_selection(card)
	hand.update_in_hand()
	return card
	
func add_card_to_shop(data: CardData) -> Card:
	var card = create_card(data)
	if !card:
		return
	shop.add_child(card)
	card.card_data = data
	ActionManager.connect_selection(card)
	card.in_shop = true
	shop.update_in_shop()
	return card

func added_business_field(data : BusinessCardData):
	var card = create_card(data)
	if !card:
		return
	field.add_child(card)
	card.card_data = data

func add_card_to_pool(card_id_list:Array[int]) -> void:
	for card_id in card_id_list:
		if card_id not in card_pool:
			card_pool.append(card_id)

func reset_shop():
	for card in shop.get_children():
		shop.remove_child(card)
		if is_instance_valid(card):
			card.queue_free()
	for i in 3:
		var _id = card_pool[GameManager.rng.randi() % card_pool.size()]
		add_card_to_shop(card_dict[_id])

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

func get_all_card(location:ECardLocation) -> Array[Card]:
	var cards:Array[Card] = []
	
	var location_node:Node
	match location:
		ECardLocation.hand:
			location_node = hand
		ECardLocation.shop:
			location_node = shop
		ECardLocation.deck:
			location_node = deck
		ECardLocation.discarded:
			location_node = discarded
			
	for node in location_node.get_children():
		if node is Card:
			cards.append(node)
	
	return cards

func move_cards_to(cards:Array[Card],target_location:ECardLocation) -> void:
	var location_node:Node
	match target_location:
		ECardLocation.hand:
			for card in cards:
				card.reparent(hand)
			hand.update_in_hand()
		#TODO
		ECardLocation.shop:
			pass
		ECardLocation.deck:
			for card in cards:
				card.reparent(deck)
		ECardLocation.discarded:
			for card in cards:
				card.reparent(discarded)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
