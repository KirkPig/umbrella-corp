extends Control
class_name HandController

@export var card_gap: float = 120
@export var hand_width: float = 1200

func _ready() -> void:
	CardManager.hand = self

func _process(delta: float) -> void:
	pass
	
func move_to_hand(node: Card):
	node.reparent(self)
	update_in_hand()
	
func get_all_card() -> Array[Node]:
	return self.get_children()
	
func update_in_hand():
	var cards = self.get_children()
	var i = 0
	for card: Card in cards:
		card.set_card_hand_position(i, cards.size(), 0, hand_width, card_gap, true)
		i+=1
