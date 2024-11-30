extends VBoxContainer
class_name UIResearchReward

@export var wallet_color: Color
@export var worker_color: Color
@export var resource_color: Color
@export var business_color: Color
@export var instant_color: Color

@onready var label = $Label
@onready var icon = $Panel/Icon
@onready var bg = $Panel

@onready var _box: StyleBoxFlat = bg.get_theme_stylebox("panel")

@onready var wallet_icon: Texture2D = load("res://Assets/Phone/walletnobg.png")

func set_gold_reward(_amount: int):
	icon.texture = wallet_icon
	_box.bg_color = wallet_color
	label.text = "$ " + str(_amount)

func set_card_reward(_id: int, _amount: int):
	var _data = CardManager.card_dict[_id]
	icon.texture = _data.card_icon
	label.text = str(_amount) + "x " + _data.card_name
	if _data is ResourceCardData:
		_box.bg_color = resource_color
	elif _data is WorkerCardData:
		_box.bg_color = worker_color
	elif _data is BusinessCardData:
		_box.bg_color = business_color
	elif _data is InstantCardData:
		_box.bg_color = instant_color

func set_unlock_business(_id: int):
	var _data: BusinessCardData = CardManager.card_dict[_id]
	icon.texture = _data.card_icon
	_box.bg_color = business_color
	label.text = "Unlock purchasable business (" + _data.card_name + ")"

func set_unlock_resource(_id: int):
	var _data: ResourceCardData = CardManager.card_dict[_id]
	var _bus: BusinessCardData = CardManager.card_dict[_data.business_id]
	icon.texture = _data.card_icon
	_box.bg_color = resource_color
	label.text = "Unlock new production (" + _data.card_name + " in " + _bus.card_name + ")"

func set_unlock_card(_id: int):
	var _data = CardManager.card_dict[_id]
	icon.texture = _data.card_icon
	label.text = "Unlock purchasable card (" + _data.card_name + ")"
	if _data is ResourceCardData:
		_box.bg_color = resource_color
	elif _data is WorkerCardData:
		_box.bg_color = worker_color
	elif _data is BusinessCardData:
		_box.bg_color = business_color
	elif _data is InstantCardData:
		_box.bg_color = instant_color
