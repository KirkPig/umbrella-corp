extends Control
class_name BusinessFieldController

@export var card_gap: float = 450
@export var hand_width: float = 850

@onready var _template_business_ui = preload("res://UI/Business/S_UI_Business.tscn")

func add_new_business(_id: int, _res_id: int) -> UIBusiness:
	var _ui: UIBusiness = _template_business_ui.instantiate()
	add_child(_ui)
	_ui.current_yield = CardManager.card_dict[_res_id]
	_ui.business_card_data = CardManager.card_dict[_id]
	update_position()
	return _ui

func update_position():
	var _nodes = self.get_children()
	var i = 0
	_nodes.sort_custom(_compare_business)
	for _node: UIBusiness in _nodes:
		_node.set_ui_position(i, _nodes.size(), 0, hand_width, card_gap, false)
		i+=1

func update_child_ui():
	for _node: UIBusiness in get_children():
		_node.button_state_checking()

func _compare_business(a: UIBusiness, b: UIBusiness) -> bool:
	return a.business_card_data.card_id < b.business_card_data.card_id

func _ready() -> void:
	CardManager.business_field = self
