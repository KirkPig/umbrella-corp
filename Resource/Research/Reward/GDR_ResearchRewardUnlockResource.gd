extends ResearchReward
class_name ResearchRewardUnlockResource

@export var unlocked_resource_id: int
@export var target_business_id: int

func can_activate(_resource: int) -> bool:
	if !super(_resource):
		return false
	var target_business: BusinessCardData = CardManager.card_dict[target_business_id]
	return (
		(target_business_id not in CardManager.card_pool) or 
		(unlocked_resource_id not in target_business.resource_yield_list)
		)

func activate() -> void:
	var target_business: BusinessCardData = CardManager.card_dict[target_business_id]
	if target_business_id not in CardManager.card_pool:
		CardManager.card_pool.append(target_business_id)
	target_business.resource_yield_list.append(unlocked_resource_id)
