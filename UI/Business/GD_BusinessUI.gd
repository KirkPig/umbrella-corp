extends Control
class_name UIBusiness

@onready var label_business_name = $Container/Detail/Title/Container/Label
@onready var icon_yield = $Container/Detail/Title/Container/Panel/Icon

@onready var label_yield = $Container/Detail/Labor/Progress/Yield
@onready var label_progress = $Container/Detail/Labor/Progress/Label
@onready var progress_bar = $Container/Detail/Labor/Progress/Value

@onready var component = $Container/Detail/Component
@onready var component_list = $Container/Detail/Component/List

@onready var btn_work = $ButtonGroup/Work
@onready var btn_component = $ButtonGroup/Component
@onready var btn_change_resource = $ButtonGroup/ChangeResource

@onready var _template_business_component = preload("res://UI/Business/Component/Scene/S_UI_BusinessComponent.tscn")

# TODO: handle when business data is changed
var business_card_data: BusinessCardData:
	set(value):
		label_business_name.text = value.card_name
		var _id = business_card_data.resource_yield_list[0]
		var _res: ResourceCardData = CardManager.card_dict[_id]
		current_yield = _res
		
		business_card_data = value

## yield selection
var current_yield: ResourceCardData:
	set(value):
		# Icon
		icon_yield.texture = value.card_icon
		# Labor progress bar
		label_yield.text = str(value.yield_piece) + "x " + value.card_name
		current_labor = 0
		labor = value.labor_per_piece
		# Component bar
		_clear_component()
		for _c in value.components:
			_add_component(_c)
		if component_list.get_child_count() > 0:
			component.show()
		else:
			component.hide()
		
		current_yield = value

## labor state
var current_labor: int = 0:
	set(value):
		current_labor = value
		label_progress.text = str(current_labor) + "/" + str(labor)
		
		progress_bar.value = value
var labor: int = 4:
	set(value):
		labor = value
		label_progress.text = str(current_labor) + "/" + str(labor)
		
		progress_bar.max_value = value

func _clear_component():
	for item in component_list.get_children():
		component_list.remove_child(item)
		if is_instance_valid(item):
			item.queue_free()

func _add_component(_data: ResourceComponentItemData):
	var _component: UIBusinessComponent = _template_business_component.instantiate()
	component_list.add_child(_component)
	_component.component_data = _data

func _ready() -> void:
	pass
