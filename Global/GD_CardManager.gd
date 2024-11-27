extends Node

@onready var template_worker_card = preload("res://Card/Presets/S_Worker.tscn")
@onready var template_business_card = preload("res://Card/Presets/S_Business.tscn")
@onready var template_resource_card = preload("res://Card/Presets/S_Resource.tscn")
@onready var template_instant_card = preload("res://Card/Presets/S_Instant.tscn")
@onready var template_upgrade_card = preload("res://Card/Presets/S_Upgrad.tscn")

enum ECardLocation {
	hand,
	shop,
	field,
	deck,
	discarded,
	played
}

enum ECardType {
	all,
	worker,
	business,
	resource,
	instant,
	upgrade,
}

var card_dict: Dictionary = {}

var field: FieldController
var hand: HandController
var shop: ShopController
var deck: Control
var discarded: Control
var played: Control

var card_pool: Array[int]

func unlock_resource(_id: int):
	var _res_data: ResourceCardData = card_dict[_id]
	var _bus_data: BusinessCardData = card_dict[_res_data.business_id]
	if _bus_data.card_id not in card_pool:
		card_pool.append(_bus_data.card_id)
	if _res_data.card_id not in card_pool:
		card_pool.append(_res_data.card_id)
	if _res_data.card_id not in _bus_data.resource_yield_list:
		_bus_data.resource_yield_list.append(_res_data.card_id)
	pass

func get_card_pool(_type: ECardType) -> Array[int]:
	var from: int
	var to: int
	match _type:
		ECardType.all:
			from = 0
			to = 10000
		ECardType.worker:
			from = 0
			to = 1000
		ECardType.business:
			from = 1000
			to = 2000
		ECardType.resource:
			from = 2000
			to = 3000
		ECardType.instant:
			from = 3000
			to = 4000
		ECardType.upgrade:
			from = 4000
			to = 10000
	
	var cards: Array[int]
	for id in card_pool:
		if id >= from and id < to:
			cards.append(id)
	
	return cards

func random_card_pool(_type: ECardType) -> int:
	var cards = get_card_pool(_type)
	return cards[GameManager.rng.randi() % cards.size()]

func _ready() -> void:
	load_cards("res://Resource/Card/Business/")
	load_cards("res://Resource/Card/Resource/")
	load_cards("res://Resource/Card/Worker/")
	load_cards("res://Resource/Card/Instant/")
	load_cards("res://Resource/Card/Upgrade/")

func load_cards(_path: String) -> void:
	var _card_res = DirAccess.get_files_at(_path)
	for _files in _card_res:
		var data: CardData = load(_path + _files)
		card_dict[data.card_id] = data

func add_card(_id: int, _target: Control) -> Card:
	var data = card_dict[_id]
	var card
	if data is WorkerCardData:
		card = create_worker_card()
	elif data is BusinessCardData:
		card = create_business_card()
	elif data is ResourceCardData:
		card = create_resource_card()
	elif data is InstantCardData:
		card = create_instant_card()
	elif data is UpgradeCardData:
		card = create_upgrade_card()
	else:
		return
	
	_target.add_child(card)
	card.card_data = data
	return card

func create_worker_card() -> WorkerCard:
	var card : WorkerCard = template_worker_card.instantiate()
	card.is_buy.connect(ActionManager.action_buy)
	return card

func create_business_card() -> BusinessCard:
	var card : BusinessCard = template_business_card.instantiate()
	card.is_buy.connect(ActionManager.action_buy)
	card.selected_work.connect(ActionManager.action_work)
	return card

func create_resource_card() -> ResourceCard:
	var card : ResourceCard = template_resource_card.instantiate()
	card.is_buy.connect(ActionManager.action_buy)
	return card

func create_instant_card() -> InstantCard:
	var card : InstantCard = template_instant_card.instantiate()
	card.is_buy.connect(ActionManager.action_buy)
	return card

func create_upgrade_card() -> UpgradeCard:
	var card : UpgradeCard= template_upgrade_card.instantiate()
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

func get_all_card(location: ECardLocation) -> Array[Card]:
	var cards:Array[Card] = []
	
	var location_node: Node
	match location:
		ECardLocation.hand:
			location_node = hand
		ECardLocation.shop:
			location_node = shop.card_node
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

func move_cards_to(cards:Array[Card], target_location: ECardLocation) -> void:
	match target_location:
		ECardLocation.hand:
			for card in cards:
				card.is_selected = false
				hand.add_exists(card)
		ECardLocation.shop:
			for card in cards:
				card.is_selected = false
				shop.card_node.add_exists(card)
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
