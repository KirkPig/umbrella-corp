extends Control
class_name Contract

@export var contract_res: ResourceContract
@onready var contract_name: Label = $Contract/Container/Name
@onready var description: Label = $Contract/Container/Description
@onready var turn_limit: Label = $Contract/Container/HBoxContainer2/TurnLimit
@onready var score: Label = $Contract/Container/HBoxContainer/Score
@onready var reward: Label = $Contract/Container/HBoxContainer3/Reward

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contract_name.text = contract_res.name
	description.text = contract_res.description
	turn_limit.text = str(contract_res.turn_limit)
	score.text = str(contract_res.score_goal)
	reward.text = str(contract_res.reward_gold)
	#print("reward", typeof(contract_res.reward_type))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# TODO:check id score pass
func check_finish_contract() -> bool:
	return false


func _on_select_button_pressed() -> void:
	GameManager.select_contract(contract_res)
