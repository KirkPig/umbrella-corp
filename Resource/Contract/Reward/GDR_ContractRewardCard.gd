extends ContractReward
class_name ContractRewardCard

enum ECardLocation{
	pool,
	deck
}

@export var reward_card_location: ECardLocation
@export var reward_card_id: int

func get_reward() -> void:
	match reward_card_location:
		ECardLocation.pool:
			CardManager.add_card_to_pool([reward_card_id])
			GameManager.contract_reward.add_unlock_card(reward_card_id)
		ECardLocation.deck:
			for _i in amount:
				CardManager.add_card_to_deck(reward_card_id)
			GameManager.contract_reward.add_card_reward(reward_card_id, amount)
