extends Control
class_name ShopController

@export var card_gap: float = 200
@export var shop_width: float = 800

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CardManager.shop = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_all_card() -> Array[Node]:
	return self.get_children()
	
func update_in_shop():
	var cards = self.get_children()
	var i = 0
	for card: Card in cards:
		card.set_card_hand_position(i, cards.size(), 0, shop_width, card_gap, false)
		i+=1
	pass

func reset_shop():
	for card in self.get_children():
		self.remove_child(card)
		if is_instance_valid(card):
			card.queue_free()
	for i in 3:
		var _id = CardManager.card_pool[GameManager.rng.randi() % CardManager.card_pool.size()]
		add_card_to_shop(_id)

func add_card_to_shop(_id: int) -> Card:
	var card = CardManager.add_card(_id, self)
	if !card:
		return
	ActionManager.connect_selection(card)
	card.in_shop = true
	update_in_shop()
	return card
