extends ContractReward
class_name ContractRewardResource

enum ERewaredResource{
	gold,
	score,
	max_energy,
	max_hand
}

@export var reward_amount : int
@export var reward_resource : ERewaredResource


func get_reward() -> void:
	
	match reward_resource:
		ERewaredResource.gold:
			GameManager.gold += reward_amount
					
		ERewaredResource.score:
			GameManager.current_score += reward_amount
					
		ERewaredResource.max_energy:
			GameManager.max_energy += reward_amount
					
		ERewaredResource.max_hand:
			GameManager.max_hand += reward_amount
