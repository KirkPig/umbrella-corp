extends Resource
class_name ContractData


@export var name: String
@export var description: String
@export var turn_limit: int
@export var score_goal: int
@export_multiline var reward_text: String
@export var reward_list: Array[ContractReward]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func check_finish_contract(score: int) -> bool:
	return score >= score_goal

func get_reward() -> void:
	for reward in reward_list:
		reward.get_reward()
