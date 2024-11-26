extends ResearchReward
class_name ResearchRewardUnlockResource

@export var unlocked_resource_id: int

func can_activate(_resource: int) -> bool:
	if !super(_resource):
		return false
	var _data: ResourceCardData = CardManager.card_dict[unlocked_resource_id]
	var target_business: BusinessCardData = _data.get_business_card_data()
	return (
		(target_business.card_id not in CardManager.card_pool) or 
		(unlocked_resource_id not in target_business.resource_yield_list)
		)

func activate() -> void:
	var _data: ResourceCardData = CardManager.card_dict[unlocked_resource_id]
	var target_business = _data.get_business_card_data()
	if target_business.card_id not in CardManager.card_pool:
		CardManager.card_pool.append(target_business.card_id)
	target_business.resource_yield_list.append(unlocked_resource_id)
