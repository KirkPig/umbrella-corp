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
@onready var btn_sell = $Sell

@onready var _template_business_component = preload("res://UI/Business/Component/Scene/S_UI_BusinessComponent.tscn")

@export_category("Oscillator")
@export var spring: float = 500.0
@export var damp: float = 20.0
@export var velocity_multiplier: float = 10.0

var tween_moving: Tween

var displacement: float = 0.0 
var oscillator_velocity: float = 0.0

var last_pos: Vector2
var velocity: Vector2

# TODO: sell business
# TODO: handle when business data is changed
var business_card_data: BusinessCardData:
	set(value):
		label_business_name.text = value.card_name
		var _id = value.resource_yield_list[0]
		var _res: ResourceCardData = CardManager.card_dict[_id]
		current_yield = _res
		sell_price = value.shop_price / 10 * 8
		business_card_data = value
		
		button_state_checking()

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
		if !can_use_components():
			return
		while value >= labor:
			_yield_resource()
			value -= labor
		current_labor = value
		label_progress.text = str(current_labor) + "/" + str(labor)
		
		progress_bar.value = value
var labor: int = 4:
	set(value):
		labor = value
		label_progress.text = str(current_labor) + "/" + str(labor)
		
		progress_bar.max_value = value

var sell_price: int = 0:
	set(value):
		btn_sell.text = "Sell ($" + str(value) + ")"
		sell_price = value

var components: Dictionary

func hide_all_button():
	btn_work.hide()
	btn_component.hide()
	btn_change_resource.hide()
	btn_sell.hide()

func button_state_checking():
	btn_sell.show()
	
	var selected_cards = CardManager.get_selected_card()
	var resource_components = current_yield.components
	btn_work.visible = GameManager.can_work(selected_cards) and can_use_components()
	btn_component.visible = GameManager.can_add_components(selected_cards, resource_components)
	btn_change_resource.visible = GameManager.can_business_change_resource(business_card_data.card_id)
	
func change_position(_pos: Vector2, _time: float):
	if tween_moving and tween_moving.is_running():
		tween_moving.kill()
	tween_moving = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.NOTIFICATION_PREDELETE)
	tween_moving.tween_property(self, "position", _pos, _time)

func set_ui_position(_card_pos: int, _in_hand: int, _min_x: float, _max_x: float, _card_min_x: float, in_hand: bool):
	var _middle_pos = (_max_x + _min_x) / 2
	var _pos_x: float
	var _pos_y: float
	if _in_hand == 1:
		_pos_x = _middle_pos
		_pos_y = 0
	else:
		_pos_x = remap(_card_pos, 0, _in_hand - 1, 
			max(_min_x, _middle_pos - (_card_min_x / 2 * (_in_hand - 1))), 
			min(_max_x, _middle_pos + (_card_min_x / 2 * (_in_hand - 1))),
		)
		_pos_y = remap(abs(_pos_x - _middle_pos), 0, _middle_pos, 0, 20)
	if !in_hand:
		_pos_y = 0
	change_position(Vector2(_pos_x, _pos_y), 0.2 / GameManager.game_speed)
	z_index = _card_pos

func added_component(_card: ResourceCard):
	components[_card.card_id].current_component += 1

func yield_labor(_worker: WorkerCard):
	current_labor += _worker.yield_labor_value(self)

func can_use_components() -> bool:
	for _id in components.keys():
		if components[_id].current_component < components[_id].need_component:
			return false
	return true

func _yield_resource():
	var _n = _use_component()
	if _n == 0:
		return
	var _c: Card = CardManager.add_card_to_deck(current_yield.card_id)
	CardManager.discard(_c)

func _use_component() -> int:
	if !can_use_components():
		return 0
	
	for _id in components.keys():
		components[_id].current_component -= components[_id].need_component
	
	return 1

func _clear_component():
	for item in component_list.get_children():
		component_list.remove_child(item)
		if is_instance_valid(item):
			item.queue_free()
	components = {}

func _add_component(_data: ResourceComponentItemData):
	var _component: UIBusinessComponent = _template_business_component.instantiate()
	component_list.add_child(_component)
	_component.component_data = _data
	components[_data.resource_id] = _component

func _rotate_velocity(delta: float) -> void:
	var center_pos: Vector2 = position + pivot_offset
	# Compute the velocity
	velocity = (position - last_pos) / delta
	last_pos = position
	
	oscillator_velocity += velocity.normalized().x * velocity_multiplier
	
	# Oscillator stuff
	var force = -spring * displacement - damp * oscillator_velocity
	oscillator_velocity += force * delta
	displacement += oscillator_velocity * delta
	
	rotation = deg_to_rad(displacement)

func _process(delta: float) -> void:
	_rotate_velocity(delta)

# TODO: handle the transition when the button is shown/hiden
#@onready var btn_work_last_pos: Vector2 = btn_work.position
#
#func _process(delta: float) -> void:
	#if btn_work_last_pos != btn_work.position: _handle_work_transition()
#
#var is_tween_btn_work_running: bool
#var tween_btn_work: Tween
#
#func _handle_work_transition():
	#if is_tween_btn_work_running: return
	#if tween_btn_work and tween_btn_work.is_running():
		#tween_btn_work.kill()
	#is_tween_btn_work_running = true
	#var _target_pos = btn_work.position
	#btn_work.position = btn_work_last_pos
	#btn_work_last_pos = _target_pos
	#tween_btn_work = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	#tween_btn_work.tween_property(btn_work, "position", _target_pos, 0.7)
	#await tween_btn_work.finished
	#is_tween_btn_work_running = false
	#btn_work_last_pos = _target_pos


func _on_sell_pressed() -> void:
	ActionManager.action_sell_business(self)
	pass # Replace with function body.


func _on_work_pressed() -> void:
	ActionManager.action_work(self)
	pass # Replace with function body.


func _on_component_pressed() -> void:
	ActionManager.action_add_component(self)
	pass # Replace with function body.


func _on_change_resource_pressed() -> void:
	pass # Replace with function body.
