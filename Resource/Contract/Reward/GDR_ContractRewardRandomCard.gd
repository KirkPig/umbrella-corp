extends ContractReward
class_name ContractRewardRandomCard

@export var reward_card_type: CardManager.ECardType

func get_reward() -> void:
	var _dict: Dictionary
	var _old: Dictionary
	for i in amount:
		var _id = CardManager.random_card_pool(reward_card_type)
		if reward_card_type == CardManager.ECardType.business:
			CardManager.add_card_to_field(_id)
		elif reward_card_type == CardManager.ECardType.upgrade:
			var _data: UpgradeCardData = CardManager.card_dict[_id]
			if _id not in _old:
				_old[_id] = _data.current_state()
			_data.played()
		else:
			CardManager.add_card_to_deck(_id)
		
		if _id not in _dict:
			_dict[_id] = 1
		else:
			_dict[_id] += 1
	
	for _id in _dict:
		if _id >= 4000:
			var _data: UpgradeCardData = CardManager.card_dict[_id]
			GameManager.contract_reward.add_upgrade(_id, _old[_id], _data.current_state())
		else:
			GameManager.contract_reward.add_card_reward(_id, _dict[_id])
	pass
