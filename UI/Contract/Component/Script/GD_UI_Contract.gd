extends Control
class_name UIContract

signal checking_contract(_ui: UIContract)
signal choose_contract(_data: UIContract)

@onready var template_reward_small = preload("res://UI/Contract/Component/Scene/S_UI_ContractRewardSmall.tscn")
@onready var template_reward_large = preload("res://UI/Contract/Component/Scene/S_UI_ContractRewardLarge.tscn")

@onready var label_deadline = $Description/Deadline/Container/Value
@onready var label_target = $Description/Target/Container/Value

@onready var selecting_frame = $SelectFrame

@onready var btn_choose = $Choose
@onready var reward_list = $Reward
@onready var reward_desc = $RewardDesc

@export_category("Oscillator")
@export var spring: float = 500.0
@export var damp: float = 20.0
@export var velocity_multiplier: float = 4.0

var tween_moving: Tween

var displacement: float = 0.0 
var oscillator_velocity: float = 0.0

var last_pos: Vector2
var velocity: Vector2

var is_disable_selection: bool = false
var is_selected: bool:
	set(value):
		if value:
			btn_choose.show()
			reward_desc.show()
			selecting_frame.hide()
		else:
			btn_choose.hide()
			reward_desc.hide()
			selecting_frame.show()
		is_selected = value

var data: ContractData:
	set(value):
		deadline = value.turn_limit + GameManager.total_turn
		target = value.score_goal
		_clear_reward()
		for _item in value.reward_list:
			_add_reward(_item)
		data = value

var deadline = 7:
	set(value):
		deadline = value
		label_deadline.text = str(value)
var target = 650:
	set(value):
		target = value
		label_target.text = str(value)

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

func _ready() -> void:
	is_selected = false

func _clear_reward():
	for item in reward_list.get_children():
		reward_list.remove_child(item)
		if is_instance_valid(item):
			item.queue_free()

func _add_reward(_data: ContractReward):
	var item: UIContractRewardSmall = template_reward_small.instantiate()
	reward_list.add_child(item)
	item.contract_reward_data = _data
	var desc: UIContractRewardLarge = template_reward_large.instantiate()
	reward_desc.add_child(desc)
	desc.contract_reward_data = _data

func _on_reward_resized() -> void:
	reward_list.position.y = 228 - (((reward_list.size.y / 32) - 1) * 16)
	pass # Replace with function body.

func _on_select_frame_pressed() -> void:
	if is_disable_selection: return
	is_selected = true
	checking_contract.emit(self)

func _on_choose_pressed() -> void:
	choose_contract.emit(self)
