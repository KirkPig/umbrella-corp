extends Control
class_name HandController

@export var hand_width: float = 1200

func _ready() -> void:
	CardManager.hand = self

func _process(delta: float) -> void:
	pass

func update_in_hand():
	var cards = self.get_children()
	var i = 0
	for card: Card in cards:
		card.set_card_hand_position(i, cards.size(), 0, hand_width, 180, true)
		i+=1
	pass
