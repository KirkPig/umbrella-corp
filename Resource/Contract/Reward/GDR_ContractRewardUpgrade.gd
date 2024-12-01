extends ContractReward
class_name ContractRewardUpgrade

@export var reward_upgrade_id : int

func get_reward() -> void:
	var _data: UpgradeCardData = CardManager.card_dict[reward_upgrade_id]
	var _old: int = _data.current_state()
	_data.played()
	GameManager.contract_reward.add_upgrade(reward_upgrade_id, _old, _data.current_state())
	
