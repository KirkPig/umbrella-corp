extends ResearchReward
class_name ResearchRewardBonus

signal reward_bonus_gold_result(_amount: int)
signal reward_bonus_card_result(_id: int, _amount: int)

enum ERewardBonusResource {
	gold,
	card
}

@export var reward_type: ERewardBonusResource
@export var card_reward_id: int
@export var amount_from: int
@export var amount_to: int

func can_activate(_resource: int) -> bool:
	if !super(_resource):
		return false
	match reward_type:
		ERewardBonusResource.gold:
			return true
		ERewardBonusResource.card:
			return card_reward_id in CardManager.card_pool
	return true

func activate() -> void:
	match reward_type:
		ERewardBonusResource.gold:
			var _range = amount_to - amount_from + 2
			var _amount = amount_from + (GameManager.rng.randi() % _range)
			GameManager.gold += _amount
			reward_bonus_gold_result.emit(_amount)
		ERewardBonusResource.card:
			var _range = amount_to - amount_from + 2
			var _amount = amount_from + (GameManager.rng.randi() % _range)
			for i in _amount:
				CardManager.add_card_to_hand(card_reward_id)
			reward_bonus_card_result.emit(card_reward_id, _amount)
