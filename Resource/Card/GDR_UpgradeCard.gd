extends CardData
class_name UpgradeCardData

enum EUpgrade{
	HAND,
	SHOP,
	MAX_ENERGY,
	MAX_DISCARD,
	RESOURE_DEMAND,
	RESOURE_SCORE,
	RESOURE_GOLD,
}

@export var upgrade_type : EUpgrade
@export var upgrade_resoruce_id : int = -1
@export var upgrade_resoruce_icon : Texture2D
@export var upgrade_amount : int

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
			if upgrade_resoruce_id in SellManager.card_sell_bonus[SellManager.EResource.DEMAND]:
				SellManager.card_sell_bonus[SellManager.EResource.DEMAND][upgrade_resoruce_id] += upgrade_amount
			else :
				SellManager.card_sell_bonus[SellManager.EResource.DEMAND][upgrade_resoruce_id] = upgrade_amount
		EUpgrade.RESOURE_SCORE:
			if upgrade_resoruce_id in SellManager.card_sell_bonus[SellManager.EResource.SCORE]:
				SellManager.card_sell_bonus[SellManager.EResource.SCORE][upgrade_resoruce_id] += upgrade_amount
			else :
				SellManager.card_sell_bonus[SellManager.EResource.SCORE][upgrade_resoruce_id] = upgrade_amount
		EUpgrade.RESOURE_GOLD:
			if upgrade_resoruce_id in SellManager.card_sell_bonus[SellManager.EResource.GOLD]:
				SellManager.card_sell_bonus[SellManager.EResource.GOLD][upgrade_resoruce_id] += upgrade_amount
			else :
				SellManager.card_sell_bonus[SellManager.EResource.GOLD][upgrade_resoruce_id] = upgrade_amount
			
			
