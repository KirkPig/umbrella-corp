extends Resource
class_name ResourceContract

enum RewardType{
	Gold,
	Card,
	Unlock,
	Upgrade
}

@export var name:String
@export var description: String
@export var turn_limit:int
@export var score_goal:int
@export_category('Reward')
@export var reward_type:RewardType
@export var reward_gold:int
@export var reward_card:RewardType
@export var reward_unlock_card:RewardType
@export var reward_upgrade:RewardType


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func check_finish_contract(score:int) -> bool:
	return score >= score_goal
