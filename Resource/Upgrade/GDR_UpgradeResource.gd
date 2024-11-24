extends Card
class_name UpgradeResourceData

enum EUpgradeResource{
	YIELD,
	DEMAND,
	PRICE,
}

@export var reward_amount : int
@export var reward_resource : EUpgradeResource

#TODO:
func get_reward() -> void:
	
	match reward_resource:
		EUpgradeResource.YIELD:
			GameManager.gold += reward_amount
					
		EUpgradeResource.DEMAND:
			GameManager.current_score += reward_amount
					
		EUpgradeResource.PRICE:
			GameManager.max_energy += reward_amount
					
