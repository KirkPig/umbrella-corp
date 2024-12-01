extends ResearchReward
class_name ResearchRewardUnlockResource

signal reward_bonus_unlock_resource_result(_id: int)
signal reward_bonus_unlock_business_result(_id: int)

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
	var _result = CardManager.unlock_resource(unlocked_resource_id)
	if _result[0] != -1:
		reward_bonus_unlock_business_result.emit(_result[0])
	if _result[1] != -1:
		reward_bonus_unlock_resource_result.emit(_result[1])
