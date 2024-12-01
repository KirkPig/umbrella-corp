extends CardData
class_name UpgradeCardData

enum EUpgradeResource{
	RESOURE_DEMAND,
	RESOURE_SCORE,
	RESOURE_GOLD,
	RESOURE_YEILD
}

enum EUpgrade{
	HAND,
	SHOP,
	MAX_ENERGY,
	MAX_DISCARD,
	RESOURE_DEMAND,
	RESOURE_SCORE,
	RESOURE_GOLD,
	RESOURE_YEILD
}

@export var upgrade_type : EUpgrade
@export var upgrade_resoruce_id : int = -1
@export var upgrade_resoruce_icon : Texture2D
@export var upgrade_amount : int

func current_state() -> int:
	match upgrade_type:
		EUpgrade.HAND:
			return GameManager.max_hand
		EUpgrade.SHOP:
			return GameManager.max_shop_refresh
		EUpgrade.MAX_ENERGY:
			return GameManager.max_energy * 25
		EUpgrade.MAX_DISCARD:
			return GameManager.max_discard_energy
		EUpgrade.RESOURE_DEMAND:
			var _data: ResourceCardData = CardManager.card_dict[upgrade_resoruce_id]
			return _data.yield_demand
		EUpgrade.RESOURE_SCORE:
			var _data: ResourceCardData = CardManager.card_dict[upgrade_resoruce_id]
			return _data.yield_price
		EUpgrade.RESOURE_GOLD:
			var _data: ResourceCardData = CardManager.card_dict[upgrade_resoruce_id]
			return _data.yield_gold
		EUpgrade.RESOURE_YEILD:
			var _data: ResourceCardData = CardManager.card_dict[upgrade_resoruce_id]
			return _data.yield_piece
		_:
			return 0

func played() -> void:
	match upgrade_type:
		EUpgrade.HAND:
			GameManager.max_hand += 1
			CardManager.fill_hand()
		EUpgrade.SHOP:
			GameManager.max_shop_refresh += 1
		EUpgrade.MAX_ENERGY:
			GameManager.max_energy += 1
		EUpgrade.MAX_DISCARD:
			GameManager.max_discard_energy += 1
		EUpgrade.RESOURE_DEMAND:
			var _data: ResourceCardData = CardManager.card_dict[upgrade_resoruce_id]
			_data.yield_demand += upgrade_amount
		EUpgrade.RESOURE_SCORE:
			var _data: ResourceCardData = CardManager.card_dict[upgrade_resoruce_id]
			_data.yield_price += upgrade_amount
		EUpgrade.RESOURE_GOLD:
			var _data: ResourceCardData = CardManager.card_dict[upgrade_resoruce_id]
			_data.yield_gold += upgrade_amount
		EUpgrade.RESOURE_YEILD:
			var _data: ResourceCardData = CardManager.card_dict[upgrade_resoruce_id]
			_data.yield_piece += upgrade_amount
