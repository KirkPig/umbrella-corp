extends Control
class_name ShopController

@onready var card_node = $Control3/ShopController
@onready var card_price_label = $Control/BuyButton/Label
@onready var shop_refresh_label = $Control2/ResetButton2/Control/Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CardManager.shop = self
	GameManager.current_shop_refresh_change.connect(_on_shop_refresh_change)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_all_card() -> Array[Node]:
	return card_node.get_children()

func reset_shop():
	for card in card_node.get_children():
		card_node.remove_child(card)
		if is_instance_valid(card):
			card.queue_free()
	var _id = CardManager.card_pool[GameManager.rng.randi() % CardManager.card_pool.size()]
	add_card_to_shop(_id)

func add_card_to_shop(_id: int) -> Card:
	var card = CardManager.add_card(_id, card_node)
	if !card:
		return
	card.in_shop = true
	card_price_label.text = "$ "+str(card.card_data.shop_price)
	return card

func _on_shop_refresh_change(value:int) -> void:
	shop_refresh_label.text = "Free (" + str(value) +")"

func _on_buy_button_pressed() -> void:
	var card_list = card_node.get_children()
	if ActionManager.action_buy(card_list[0]):
		reset_shop()


func _on_reset_button_2_pressed() -> void:
	if GameManager.shop_refresh > 0:
		GameManager.shop_refresh -= 1
		reset_shop()
