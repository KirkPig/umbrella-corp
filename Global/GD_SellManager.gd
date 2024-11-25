extends Node

enum ETimesType{
	TIMES,
	TURN
}
enum EResource{
	SCORE,
	DEMAND,
	GOLD
}
enum EType{
	MULTIPLY,
	ADD,
}

var bonus_effect_list :Array[SellBonusEffect]= []

var all_bonus :Dictionary = {}
var card_sell_bonus :Dictionary = {
	EResource.SCORE:{},
	EResource.DEMAND:{},
	EResource.GOLD:{},
}

func _ready() -> void:
	for data_type in EResource:
		all_bonus[EResource[data_type]] = {}
		for target in ResourceCardData.EBusiness:
			all_bonus[EResource[data_type]][ResourceCardData.EBusiness[target]] = {
				EType.MULTIPLY: 1,
				EType.ADD : 0,
			}

func sell(selected_card)-> void:
	cal_sell_gold(selected_card)
	cal_sell_score(selected_card)
	for bonus in bonus_effect_list:
		bonus.sell()
			
func end_turn()-> void:
	for bonus in bonus_effect_list:
		bonus.end_turn()

func cal_sell_gold(sell_card:Array[Card]):
	var price  = 0
	for card : ResourceCard in sell_card:
		if card.card_id in SellManager.card_sell_bonus[SellManager.EResource.GOLD]:
			price += SellManager.card_sell_bonus[SellManager.EResource.GOLD][card.card_id]
		price += card.yield_gold + all_bonus[EResource.GOLD][card.business][EType.ADD]
	GameManager.gold += int(price * all_bonus[EResource.GOLD][ResourceCardData.EBusiness.ALL][EType.MULTIPLY]) + all_bonus[EResource.GOLD][ResourceCardData.EBusiness.ALL][EType.ADD] 
						

func cal_sell_score(sell_card:Array[Card]):	
	var _dict : Dictionary = {}
	var price = 0
	for card : ResourceCard in sell_card:
		if card.card_id in SellManager.card_sell_bonus[SellManager.EResource.SCORE]:
			price += SellManager.card_sell_bonus[SellManager.EResource.SCORE][card.card_id]
		price += card.yield_score + all_bonus[EResource.SCORE][card.business][EType.ADD] 
		
	var demand : int = 0
	for card : ResourceCard in sell_card:
		if card.card_id in SellManager.card_sell_bonus[SellManager.EResource.DEMAND]:
			demand += SellManager.card_sell_bonus[SellManager.EResource.DEMAND][card.card_id]
		demand += card.demand + all_bonus[EResource.DEMAND][card.business][EType.ADD] 

	GameManager.current_score += price * all_bonus[EResource.SCORE][ResourceCardData.EBusiness.ALL][EType.MULTIPLY] + all_bonus[EResource.SCORE][ResourceCardData.EBusiness.ALL][EType.ADD]
