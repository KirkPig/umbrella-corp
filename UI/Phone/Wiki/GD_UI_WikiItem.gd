extends HBoxContainer
class_name UIWikiItem

@onready var _resource_icon = $ResourceLabel/Icon
@onready var _resource_label = $ResourceLabel/Label
@onready var _price = $Value/Price/Label
@onready var _demand = $Value/Demand/Label
@onready var _gold = $Value/Gold/Label

var data: ResourceCardData:
	set(value):
		_resource_icon.texture = value.card_icon
		_resource_label.text = value.card_name
		_price.text = str(value.yield_price)
		_demand.text = str(value.yield_demand)
		_gold.text = str(value.yield_gold)
		
		data = value
