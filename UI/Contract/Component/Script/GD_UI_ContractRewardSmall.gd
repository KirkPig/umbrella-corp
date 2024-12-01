extends Control
class_name UIContractRewardSmall

@onready var node_panel: Panel = $Panel
@onready var node_icon: TextureRect = $Panel/Icon
@onready var node_label: Label = $Label

@onready var _icon_wallet: Texture2D = preload("res://Assets/Phone/walletnobg.png")
@onready var _icon_random: Texture2D = preload("res://Assets/UI/Contract/question_mark.png")
@onready var _icon_demand: Texture2D = preload("res://Assets/Tooltip/Demand.png")
@onready var _icon_price: Texture2D = preload("res://Assets/Tooltip/Price.png")

var contract_reward_data:
	set(value):
		if contract_reward_data:
			contract_reward_data.changed.disconnect(set_data)
		value.changed.connect(set_data)
		contract_reward_data = value
		set_data(value)

func set_data(_data):
	node_label.show()
	var _style: StyleBoxFlat = node_panel.get_theme_stylebox("panel")
	if _data is ContractRewardGold:
		node_label.text = "$" + str(_data.amount)
		node_icon.texture = _icon_wallet
		_style.bg_color = GameManager.wallet_color
	elif _data is ContractRewardRandomCard:
		node_label.text = "x" + str(_data.amount)
		node_icon.texture = _icon_random
		match _data.reward_card_type:
			CardManager.ECardType.worker:
				_style.bg_color = GameManager.worker_color
			CardManager.ECardType.business:
				_style.bg_color = GameManager.business_color
			CardManager.ECardType.resource:
				_style.bg_color = GameManager.resource_color
			CardManager.ECardType.instant:
				_style.bg_color = GameManager.instant_color
			CardManager.ECardType.upgrade:
				_style.bg_color = GameManager.upgrade_color
	elif _data is ContractRewardCard:
		var _card_data = CardManager.card_dict[_data.reward_card_id]
		node_label.text = "x" + str(_data.amount)
		node_icon.texture = _card_data.card_icon
	elif _data is ContractRewardUpgrade:
		var _card_data: UpgradeCardData = CardManager.card_dict[_data.reward_upgrade_id]
		node_icon.texture = _card_data.card_icon
		_style.bg_color = GameManager.upgrade_color
		if _data.reward_upgrade_id < 6000:
			node_label.hide()
		else:
			var _res_id = 2000 + (_data.reward_upgrade_id % 1000)
			var _res_data: ResourceCardData = CardManager.card_dict[_res_id]
			node_label.text = _res_data.card_name
			match _card_data.upgrade_type:
				UpgradeCardData.EUpgrade.RESOURE_DEMAND:
					node_icon.texture = _icon_demand
				UpgradeCardData.EUpgrade.RESOURE_SCORE:
					node_icon.texture = _icon_price
				UpgradeCardData.EUpgrade.RESOURE_GOLD:
					node_icon.texture = _icon_wallet
				UpgradeCardData.EUpgrade.RESOURE_YEILD:
					node_icon.texture = _res_data.card_icon
