extends HBoxContainer
class_name UIBusinessComponent

@onready var icon_texture = $Icon
@onready var label_name = $Name
@onready var label_value = $Value

var component_data: ResourceComponentItemData:
	set(value):
		_set_data(value)
		component_data = value

func _set_data(_data: ResourceComponentItemData):
	var _card_data = CardManager.card_dict[_data.resource_id]
