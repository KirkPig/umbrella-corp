extends HBoxContainer
class_name UIContractRewardLarge

var _color_wallet = Color("000000")

@onready var node_panel: Panel = $Panel
@onready var node_icon: TextureRect = $Panel/Icon
@onready var node_label: Label = $Label

@onready var _icon_wallet: Texture2D = preload("res://Assets/Phone/walletnobg.png")
@onready var _icon_random: Texture2D = preload("res://Assets/UI/Contract/question_mark.png")
@onready var _icon_demand: Texture2D = preload("res://Assets/Tooltip/Demand.png")
@onready var _icon_price: Texture2D = preload("res://Assets/Tooltip/Price.png")

var contract_reward_data: ContractReward:
	set(value):
		if contract_reward_data:
			contract_reward_data.changed.disconnect(set_data)
		value.changed.connect(set_data)
		contract_reward_data = value
		set_data(value)

func set_data(_data: ContractReward):
	var _style: StyleBoxFlat = node_panel.get_theme_stylebox("panel")
	if _data is ContractRewardGold:
		node_label.text = "$" + str(_data.amount)
		node_icon.texture = _icon_wallet
		_style.bg_color = _color_wallet
	elif _data is ContractRewardRandomCard:
		node_icon.texture = _icon_random
		match _data.reward_card_type:
			CardManager.ECardType.worker:
				node_label.text = str(_data.amount) + " Random worker card"
				_style.bg_color = GameManager.worker_color
			CardManager.ECardType.business:
				node_label.text = str(_data.amount) + " Random business card"
				_style.bg_color = GameManager.business_color
			CardManager.ECardType.resource:
				node_label.text = str(_data.amount) + " Random resource card"
				_style.bg_color = GameManager.resource_color
			CardManager.ECardType.instant:
				node_label.text = str(_data.amount) + " Random instant card"
				_style.bg_color = GameManager.instant_color
	elif _data is ContractRewardCard:
		var _card_data = CardManager.card_dict[_data.reward_card_id]
		node_label.text = str(_data.amount) + " " + _card_data.card_name
		node_icon.texture = _card_data.card_icon
	elif _data is ContractRewardUpgrade:
		var _card_data = CardManager.card_dict[_data.reward_upgrade_id]
		_style.bg_color = GameManager.upgrade_color
		if _data.reward_upgrade_id < 6000:
			node_icon.texture = _card_data.card_icon
			node_label.text = _card_data.card_name
		else:
			var _res_id = 2000 + (_data.reward_upgrade_id % 1000)
			var _res_data: ResourceCardData = CardManager.card_dict[_res_id]
			if _data.reward_upgrade_id < 7000:
				node_icon.texture = _res_data.card_icon
				node_label.text = "Upgrade yield prodiction on " + _res_data.card_name
			elif _data.reward_upgrade_id < 8000:
				node_icon.texture = _icon_demand
				node_label.text = "Upgrade demand on " + _res_data.card_name
			else:
				node_icon.texture = _icon_price
				node_label.text = "Upgrade price on " + _res_data.card_name
