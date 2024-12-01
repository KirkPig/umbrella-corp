extends VBoxContainer
class_name UIRewardItem

@onready var label = $Label
@onready var icon = $Panel/Icon
@onready var bg = $Panel
@onready var card_container = $CardContainer

@onready var _box: StyleBoxFlat = bg.get_theme_stylebox("panel")

@onready var wallet_icon: Texture2D = load("res://Assets/Phone/walletnobg.png")

func set_gold_reward(_amount: int):
	card_container.hide()
	bg.show()
	icon.texture = wallet_icon
	_box.bg_color = GameManager.wallet_color
	label.text = "$ " + str(_amount)

func set_card_reward(_id: int, _amount: int):
	card_container.show()
	bg.hide()
	var _data = CardManager.card_dict[_id]
	label.text = str(_amount) + "x " + _data.card_name
	for i in _amount:
		var _c: Card
		if _data is ResourceCardData:
			_c = CardManager.create_resource_card()
		elif _data is WorkerCardData:
			_c = CardManager.create_worker_card()
		elif _data is BusinessCardData:
			_c = CardManager.create_business_card()
		elif _data is InstantCardData:
			_c = CardManager.create_instant_card()
		elif _data is UpgradeCardData:
			_c = CardManager.create_upgrade_card()
		card_container.add_child(_c)
		_c.card_data = _data
	var cards = card_container.get_children()
	var i = 0
	cards.sort_custom(_compare_card)
	for card: Card in cards:
		card.set_card_hand_position(i, cards.size(), 0, 40, 400, false)
		i+=1

func set_unlock_business(_id: int):
	card_container.hide()
	bg.show()
	var _data: BusinessCardData = CardManager.card_dict[_id]
	icon.texture = _data.card_icon
	_box.bg_color = GameManager.business_color
	label.text = "Unlock purchasable business (" + _data.card_name + ")"

func set_unlock_resource(_id: int):
	card_container.hide()
	bg.show()
	var _data: ResourceCardData = CardManager.card_dict[_id]
	var _bus: BusinessCardData = CardManager.card_dict[_data.business_id]
	icon.texture = _data.card_icon
	_box.bg_color = GameManager.resource_color
	label.text = "Unlock new production (" + _data.card_name + " in " + _bus.card_name + ")"

func set_unlock_card(_id: int):
	card_container.hide()
	bg.show()
	var _data = CardManager.card_dict[_id]
	icon.texture = _data.card_icon
	label.text = "Unlock purchasable card (" + _data.card_name + ")"
	if _data is ResourceCardData:
		_box.bg_color = GameManager.resource_color
	elif _data is WorkerCardData:
		_box.bg_color = GameManager.worker_color
	elif _data is BusinessCardData:
		_box.bg_color = GameManager.business_color
	elif _data is InstantCardData:
		_box.bg_color = GameManager.instant_color

func _compare_card(a: Card, b: Card) -> bool:
	return a.card_id < b.card_id
