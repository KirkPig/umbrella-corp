extends ResearchReward
class_name ResearchRewardUnlockCard

@export var unlocked_card: CardData

func can_activate(_resource: int) -> bool:
	if !super(_resource):
		return false
	return unlocked_card not in CardManager.card_pool

func activate() -> void:
	CardManager.card_pool.append(unlocked_card)
