extends ContractReward
class_name ContractRewardUpgrade

@export var reward_upgrade_id : int

func get_reward() -> void:
	var _data: UpgradeCardData = CardManager.card_dict[reward_upgrade_id]
	_data.played()
	# TODO: add reward show
