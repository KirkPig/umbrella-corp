extends HBoxContainer
class_name UIBusinessComponent

@onready var icon_texture = $Icon
@onready var label_name = $Name
@onready var label_value = $Value

var component_data: ResourceComponentItemData:
	set(value):
		var _data: ResourceCardData = CardManager.card_dict[value.resource_id]
		icon_texture.texture = _data.card_icon
		label_name.text = _data.card_name
		current_component = 0
		need_component = value.amount
		component_data = value
var current_component: int = 0:
	set(value):
		current_component = value
		label_value.text = str(value) + " / " + str(need_component)
var need_component: int = 0:
	set(value):
		need_component = value
		label_value.text = str(current_component) + " / " + str(value)
