extends ContractReward
class_name ContractRewardGold

func get_reward() -> void:
	GameManager.gold += amount
	GameManager.contract_reward.add_gold_reward(amount)
