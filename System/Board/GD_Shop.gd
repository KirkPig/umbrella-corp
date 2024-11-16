extends Control
class_name ShopController

@export var shop_width: float = 800

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CardManager.shop = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_in_shop():
	var cards = self.get_children()
	var i = 0
	for card: Card in cards:
		card.set_card_hand_position(i, cards.size(), 0, shop_width, 250, false)
		i+=1
	pass
