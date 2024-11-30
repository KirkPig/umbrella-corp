extends HBoxContainer
class_name UIContractRewardLarge

@onready var node_panel: Panel = $Panel
@onready var node_icon: TextureRect = $Panel/Icon
@onready var node_label: Label = $Label

var contract_reward_data: ContractReward:
	set(value):
		if contract_reward_data:
			contract_reward_data.changed.disconnect(set_data)
		value.changed.connect(set_data)
		contract_reward_data = value
		set_data(value)

func set_data(_data: ContractReward):
	var _style: StyleBoxFlat = node_panel.get_theme_stylebox("panel")
	_style.bg_color = _data.icon_bg_color
	if node_icon.texture:
		node_icon.texture = _data.icon
	if _data is ContractRewardGold:
		node_label.text = "$ " + str(_data.amount)
	else:
		node_label.text = str(_data.amount) + " " + _data.name
