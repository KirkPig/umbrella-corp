extends ContractReward
class_name ContractRewardGold

enum ERewaredResource{
	gold,
}

@export var reward_resource : ERewaredResource

func get_reward() -> void:
	match reward_resource:
		ERewaredResource.gold:
			GameManager.gold += amount
