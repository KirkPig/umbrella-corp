extends Control
class_name FieldController

@export var card_gap: float = 200
@export var field_width: float = 1200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CardManager.field = self
	
func get_all_card() -> Array[Node]:
	return self.get_children()

func move_to_field(node: Card):
	node.reparent(self)
	update_in_field()

func _process(delta: float) -> void:
	pass

func update_in_field():
	var cards = self.get_children()
	var i = 0
	for card: Card in cards:
		card.set_card_hand_position(i, cards.size(), 0, field_width, card_gap, false)
		i+=1
