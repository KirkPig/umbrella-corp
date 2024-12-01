extends Control
class_name BusinessFieldController

@export var card_gap: float = 450
@export var hand_width: float = 850

@export var max_per_page: int = 3

@onready var _template_business_ui = preload("res://UI/Business/S_UI_Business.tscn")
@onready var _list = $List
@onready var btn_left = $Left
@onready var btn_right = $Right

var _left_pos = Vector2(-500, 0)
var _right_pos = Vector2(-500, 0)

var current_page: int = 0:
	set(value):
		current_page = value
		update_position()

func add_new_business(_id: int, _res_id: int) -> UIBusiness:
	var _ui: UIBusiness = _template_business_ui.instantiate()
	_list.add_child(_ui)
	_ui.current_yield = CardManager.card_dict[_res_id]
	_ui.business_card_data = CardManager.card_dict[_id]
	_ui.current_yield = CardManager.card_dict[_res_id]
	update_position()
	update_button()
	return _ui

func update_position():
	var _nodes = _list.get_children()
	_nodes.sort_custom(_compare_business)
	var k = 0
	var _start = current_page * max_per_page
	for _i in _start:
		var _node = _nodes[_i]
		_node.position = _left_pos
		_node.hide()
	var _n = min(max_per_page, _nodes.size() - _start)
	for _i in _n:
		var _node = _nodes[_start + _i]
		_node.show()
		_node.set_ui_position(_i, _n, 0, hand_width, card_gap, false)
	for _i in range(_start + _n, _nodes.size(), 1):
		var _node = _nodes[_i]
		_node.position = _right_pos
		_node.hide()
	update_button()

func update_child_ui():
	for _node: UIBusiness in _list.get_children():
		_node.button_state_checking()

func update_button():
	if current_page <= 0:
		btn_left.hide()
	else:
		btn_left.show()

	var _nodes = _list.get_children()
	if current_page >= int((_nodes.size() - 1) / max_per_page):
		btn_right.hide()
	else:
		btn_right.show()

func _compare_business(a: UIBusiness, b: UIBusiness) -> bool:
	return a.business_card_data.card_id < b.business_card_data.card_id

func _ready() -> void:
	CardManager.business_field = self


func _on_left_pressed() -> void:
	current_page -= 1


func _on_right_pressed() -> void:
	current_page += 1
