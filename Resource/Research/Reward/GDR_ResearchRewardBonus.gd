extends ResearchReward
class_name ResearchRewardBonus

enum ERewardBonusResource {
	gold,
	card
}
@export var card_reward: CardData
@export var amount: int

func can_activate(_resource: int) -> bool:
	if !super(_resource):
		return false
	match ERewardBonusResource:
		ERewardBonusResource.gold:
			return true
		ERewardBonusResource.card:
			return card_reward in CardManager.card_pool
	return true

func activate() -> void:
	match ERewardBonusResource:
		ERewardBonusResource.gold:
			GameManager.gold += amount
		ERewardBonusResource.card:
			for i in amount:
				CardManager.add_card_to_hand(card_reward)
