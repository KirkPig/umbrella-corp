extends ResearchReward
class_name ResearchRewardUnlockResource

@export var unlocked_resource: ResourceCardData
@export var target_business: BusinessCardData

func can_activate(_resource: ResourceCardData) -> bool:
	if another_resource and _resource.card_id != another_resource.card_id:
		return false
	return (
		(target_business not in CardManager.card_pool) or 
		(unlocked_resource not in target_business.resource_yield_list)
		)

func activate() -> void:
	if target_business not in CardManager.card_pool:
		CardManager.card_pool.append(target_business)
	target_business.resource_yield_list.append(unlocked_resource)
