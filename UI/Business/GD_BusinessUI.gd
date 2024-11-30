extends Control
class_name UIBusiness

@onready var label_business_name = $Container/Detail/Title/Container/Label
@onready var icon_yield = $Container/Detail/Title/Container/Panel/Icon
@onready var business_icon = $Container/Panel/Icon

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

var CENTER_POS = Vector2(210, 141)

var tween_moving: Tween

var displacement: float = 0.0 
var oscillator_velocity: float = 0.0

var last_pos: Vector2
var velocity: Vector2

var business_card_data: BusinessCardData:
	set(value):
		label_business_name.text = value.card_name
		var _id = value.resource_yield_list[0]
		var _res: ResourceCardData = CardManager.card_dict[_id]
		current_yield = _res
		sell_price = value.shop_price / 10 * 8
		change_resource_price = value.shop_price / 10 * 2
		business_card_data = value
		if value.card_icon:
			business_icon.texture = value.card_icon
		button_state_checking()

## yield selection
var current_yield: ResourceCardData:
	set(value):
		# Icon
		icon_yield.texture = value.card_icon
		# Labor progress bar
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
		if current_yield:
			current_yield.changed.disconnect(refresh_data)
		current_yield = value
		refresh_data()
		value.changed.connect(refresh_data)

func refresh_data():
	label_yield.text = str(current_yield.yield_piece) + "x " + current_yield.card_name

## labor state
var current_labor: int = 0:
	set(value):
		# TODO: labor added transition
		var _total_time = 0.4 / GameManager.game_speed
		
		var _time = 0
		while value >= labor:
			_time += 1
			value -= labor
		
		for i in _time:
			if !can_use_components():
				value = current_labor
				break
			var _tween = create_tween()
			_tween.tween_property(progress_bar, "value", labor, _total_time / (_time + 1))
			await _tween.finished
			_yield_resource()
			progress_bar.value = 0
			current_labor = 0
		
		var _tween = create_tween()
		_tween.tween_property(progress_bar, "value", value, _total_time / (_time + 1))
		await _tween.finished
		current_labor = value
var labor: int = 4:
	set(value):
		labor = value
		progress_bar.max_value = value
		_set_progress(current_labor)

var sell_price: int = 0:
	set(value):
		btn_sell.text = "Sell ($" + str(value) + ")"
		sell_price = value

var change_resource_price: int = 0:
	set(value):
		btn_change_resource.text = "Change products ($" + str(value) + ")"
		change_resource_price = value

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
	btn_change_resource.visible = GameManager.can_business_change_resource(self)
	
func change_position(_pos: Vector2, _time: float):
	if tween_moving and tween_moving.is_running():
		tween_moving.kill()
	tween_moving = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
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

func _set_progress(value):
	label_progress.text = str(int(value)) + "/" + str(labor)

func _ready() -> void:
	progress_bar.value_changed.connect(_set_progress)

func _yield_resource():
	var _n = _use_component()
	if _n == 0:
		return
	for i in current_yield.yield_piece:
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

# TODO(canceled): handle the transition when the button is shown/hiden
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
	ActionManager.action_change_resource(self)
	pass # Replace with function body.
