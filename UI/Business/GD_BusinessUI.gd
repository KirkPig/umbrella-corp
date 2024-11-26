extends Control
class_name BusinessUI

@export var test_business_card: BusinessCardData

@onready var label_business_name = $Container/Detail/Title/Container/Label

@onready var label_yield = $Container/Detail/Labor/Progress/Yield
@onready var label_progress = $Container/Detail/Labor/Progress/Label
@onready var progress_bar = $Container/Detail/Labor/Progress/Value

var business_card_data: BusinessCardData:
	set(value):
		if business_card_data:
			business_card_data.changed.disconnect(_set_data)
		value.changed.connect(_set_data)
		business_card_data = value
		current_yield = 0
		_set_data(value)

var current_yield: int = 0:
	set(value):
		var _id = business_card_data.resource_yield_list[value]
		var card: ResourceCardData = CardManager.card_dict[_id]
		label_yield.text = card.card_name
		current_yield = value
		current_labor = 0
var labor: int = 4:
	set(value):
		labor = value
		label_progress.text = str(current_labor) + "/" + str(labor)
var current_labor: int = 0:
	set(value):
		current_labor = value
		label_progress.text = str(current_labor) + "/" + str(labor)

func _ready() -> void:
	business_card_data = test_business_card

func _set_data(_data: BusinessCardData):
	label_business_name.text = _data.card_name
	pass
