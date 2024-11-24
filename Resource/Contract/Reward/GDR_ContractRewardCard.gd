extends ContractReward
class_name ContractRewardCard

enum ECardLocation{
	pool,
	deck
}

@export var reward_card_location : ECardLocation
@export var reward_card_id_list : Array[int]


func get_reward() -> void:
	match reward_card_location:
		ECardLocation.pool:
			CardManager.add_card_to_pool(reward_card_id_list)
		ECardLocation.deck:
			for reward_card_id in reward_card_id_list:
				CardManager.add_card_to_deck(reward_card_id)
