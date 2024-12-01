extends ResearchReward
class_name ResearchRewardUnlockCard

signal reward_bonus_unlock_card_result(_id: int)

@export var unlocked_card_id: int

func can_activate(_resource: int) -> bool:
	if !super(_resource):
		return false
	return unlocked_card_id not in CardManager.card_pool

func activate() -> void:
	CardManager.card_pool.append(unlocked_card_id)
	reward_bonus_unlock_card_result.emit(unlocked_card_id)
