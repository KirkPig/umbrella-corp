extends ContractReward
class_name ContractRewardRandomCard

@export var reward_card_type: CardManager.ECardType

func get_reward() -> void:
	for i in amount:
		var _id = CardManager.random_card_pool(reward_card_type)
		if reward_card_type == CardManager.ECardType.business:
			CardManager.add_card_to_field(_id)
		elif reward_card_type == CardManager.ECardType.upgrade:
			var _data: UpgradeCardData = CardManager.card_dict[_id]
			_data.played()
		else:
			CardManager.add_card_to_deck(_id)
	pass
