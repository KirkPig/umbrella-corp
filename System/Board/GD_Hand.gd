extends Control
class_name HandController

@export var card_gap: float = 120
@export var hand_width: float = 1200

func _ready() -> void:
	CardManager.hand = self

func _process(delta: float) -> void:
	pass
	
func add_exists(node: Card):
	node.reparent(self)
	update_position()
	
func get_all_card() -> Array[Node]:
	return self.get_children()

func reset_selection():
	var cards = self.get_children()
	for card: Card in cards:
		card.is_selected = false

func _compare_card(a: Card, b: Card) -> bool:
	return a.card_id < b.card_id

func update_position():
	var cards = self.get_children()
	var i = 0
	cards.sort_custom(_compare_card)
	for card: Card in cards:
		card.set_card_hand_position(i, cards.size(), 0, hand_width, card_gap, true)
		i+=1

func get_selected_card() -> Array[Card]:
	var selected_card : Array[Card]
	for card in self.get_children():
		if card is Card and card.is_selected:
			selected_card.append(card)
	return selected_card
