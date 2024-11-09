extends Node

#TODO: Setting All in Each
var field: Control
var hand: Control
var shop: Control
var deck :Control
var discarded :Control
var played :Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

#TODO
func add_card_to_deck(res:ResourceBaseCard) -> void:
	if res is ResourceWorkerCard:
		pass
		#var card : WorkerCard = worker_card.instantiate()
		#card.is_buy.connect(action_buy)
		#return card

#TODO
func added_business_field(res:ResourceBusinessCard):
	pass
	#var card : BusinessCard = create_business_card()
	#field.add_child(card)

#TODO: Shop Card 
func reset_shop():
	for card in shop.get_children():
		shop.remove_child(card)
		if is_instance_valid(card):
			card.queue_free()
	#for i in 3:
		#var card = create_worker_card()
		#shop.add_child(card)
		#card.in_shop = true
		

func draw() -> bool:
	var deck_cards = deck.get_children()
	if deck_cards.size() <= 0:
		return false
	var draw_card: Card = deck_cards[randi() % deck_cards.size()]
	draw_card.reparent(hand)
	#TODO: Action Manager
	#if !draw_card.selection_change.is_connected(check_selection_condition):
		#draw_card.selection_change.connect(check_selection_condition)
	return true
	
func fill_hand():
	while true:
		var hand_cards = hand.get_children()
		if hand_cards.size() >= GameManager.max_hand : break
		if !draw(): break
#
func reset_hand():
	for card in hand.get_children():
		discard(card)

func reset_deck():
	for card in discarded.get_children():
		card.reparent(deck)

func move_to_hand(node:Card):
	node.reparent(hand)


#TODO: Action Manager
#func check_selection_condition():
	#action_list.update_list(get_selected_card(), energy)

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
	#if card.selection_change.is_connected(check_selection_condition):
		#card.selection_change.disconnect(check_selection_condition)
#
func played_cards(cards: Array[Card]):
	for card in cards:
		played_card(card)
#
func discard(card: Card):
	card.is_selected = false
	card.reparent(discarded)
	#TODO: Action Manager
	#if card.selection_change.is_connected(check_selection_condition):
		#card.selection_change.disconnect(check_selection_condition)
#
func discards(cards: Array[Card]):
	for card in cards:
		discard(card)

func free_played_card():
	for card in played.get_children():
		played.remove_child(card)
		if is_instance_valid(card):
			card.queue_free()
			
func next_turn():
	reset_deck()
	fill_hand()
	reset_shop()

func end_turn():
	reset_hand()
	free_played_card()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass