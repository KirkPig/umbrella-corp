extends Node

@onready var template_worker_card = preload("res://Card/Presets/S_Worker.tscn")
@onready var template_business_card = preload("res://Card/Presets/S_Business.tscn")
@onready var template_resource_card = preload("res://Card/Presets/S_Resource.tscn")

enum ECardLocation {
	hand,
	shop,
	field,
	deck,
	discarded,
	played
}

var card_dict: Dictionary = {}

var field: FieldController
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

func add_card(_id: int, _target: Control) -> Card:
	var data = card_dict[_id]
	var card
	if data is WorkerCardData:
		card = create_worker_card(data)
	elif data is BusinessCardData:
		card = create_business_card(data)
	elif data is ResourceCardData:
		card = create_resource_card(data)
	else:
		return
	
	_target.add_child(card)
	card.card_data = data
	return card

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

func add_card_to_deck(_id: int) -> Card:
	var card = add_card(_id, deck)
	if !card:
		return
	return card

func add_card_to_hand(_id: int) -> Card:
	var card = add_card(_id, hand)
	if !card:
		return
	ActionManager.connect_selection(card)
	hand.update_position()
	return card

func add_card_to_field(_id: int) -> Card:
	var card = add_card(_id, field)
	if !card:
		return
	field.update_position()
	return card
	
func add_card_to_pool(card_id_list:Array[int]) -> void:
	for card_id in card_id_list:
		if card_id not in card_pool:
			card_pool.append(card_id)

func draw() -> bool:
	var deck_cards = deck.get_children()
	if deck_cards.size() <= 0:
		return false
	var draw_card: Card = deck_cards[GameManager.rng.randi() % deck_cards.size()]
	ActionManager.connect_selection(draw_card)
	move_cards_to([draw_card], ECardLocation.hand)
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
	move_cards_to(get_all_card(ECardLocation.discarded), ECardLocation.deck)

func get_selected_card() -> Array[Card]:
	return hand.get_selected_card()

func played_cards(cards: Array[Card]):
	move_cards_to(cards, ECardLocation.played)
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
	shop.reset_shop()

func get_all_card(location:ECardLocation) -> Array[Card]:
	var cards:Array[Card] = []
	
	var location_node: Node
	match location:
		ECardLocation.hand:
			location_node = hand
		ECardLocation.shop:
			location_node = shop
		ECardLocation.field:
			location_node = field
		ECardLocation.deck:
			location_node = deck
		ECardLocation.discarded:
			location_node = discarded
		ECardLocation.played:
			location_node = played
			
	for node in location_node.get_children():
		if node is Card:
			cards.append(node)
	
	return cards

func move_cards_to(cards:Array[Card], target_location:ECardLocation) -> void:
	var location_node: Node
	match target_location:
		ECardLocation.hand:
			for card in cards:
				card.is_selected = false
				hand.add_exists(card)
		ECardLocation.shop:
			for card in cards:
				card.is_selected = false
				shop.add_exists(card)
		ECardLocation.field:
			for card in cards:
				card.is_selected = false
				field.add_exists(card)
		ECardLocation.deck:
			for card in cards:
				card.is_selected = false
				card.reparent(deck)
		ECardLocation.discarded:
			for card in cards:
				card.is_selected = false
				card.reparent(discarded)
		ECardLocation.played:
			for card in cards:
				card.is_selected = false
				card.reparent(played)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
