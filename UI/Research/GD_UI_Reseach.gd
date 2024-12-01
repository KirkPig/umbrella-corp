extends Control
class_name UIResearchReward

signal show_research_reward_done

@onready var background = $Background
@onready var list = $List

@onready var _template_reward_item = preload("res://UI/Component/Scene/S_UI_RewardItem.tscn")
@onready var _placeholder = $Placeholder
var _background_visibility: float = 1:
	set(value):
		background.modulate.a = value
		_background_visibility = value
var _placeholder_visibility: float = 1:
	set(value):
		_placeholder.modulate.a = value
		_placeholder_visibility = value
var _list_visibility: float = 1:
	set(value):
		list.modulate.a = value
		_list_visibility = value

func clear_reward():
	for _node in list.get_children():
		list.remove_child(_node)
		if is_instance_valid(_node):
			_node.queue_free()

func add_gold_reward(_amount: int):
	var _ui: UIRewardItem = _create_blank_research_reward()
	_ui.set_gold_reward(_amount)
	
func add_card_reward(_id: int, _amount: int):
	var _ui: UIRewardItem = _create_blank_research_reward()
	_ui.set_card_reward(_id, _amount)

func add_unlock_business(_id: int):
	var _ui: UIRewardItem = _create_blank_research_reward()
	_ui.set_unlock_business(_id)

func add_unlock_resource(_id: int):
	var _ui: UIRewardItem = _create_blank_research_reward()
	_ui.set_unlock_resource(_id)

func add_unlock_card(_id: int):
	var _ui: UIRewardItem = _create_blank_research_reward()
	_ui.set_unlock_card(_id)

func _create_blank_research_reward() -> UIRewardItem:
	var _ui: UIRewardItem = _template_reward_item.instantiate()
	list.add_child(_ui)
	return _ui

func _ready() -> void:
	ActionManager.research_reward_summary = self


func _on_button_pressed() -> void:
	_placeholder_visibility = 1
	_list_visibility = 1
	_background_visibility = 1
	var tween: Tween
	tween = create_tween()
	tween.tween_property(self, "_placeholder_visibility", 0, 0.2)
	tween.set_parallel().tween_property(self, "_list_visibility", 0, 0.2)
	tween.set_parallel().tween_property(self, "_background_visibility", 0, 0.2)
	await tween.finished
	show_research_reward_done.emit()
	_placeholder_visibility = 1
	_list_visibility = 1
	_background_visibility = 1
