extends ContractReward
class_name ContractRewardCard

@export var reward_amount : int
@export var reward_card_id_list : Array[int]


func get_reward() -> void:
	CardManager.add_card_to_pool(reward_card_id_list)
