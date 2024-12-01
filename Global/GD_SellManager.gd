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

var sell_history:Dictionary = {}


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
		sell_history[card.card_id] = 1 if card.card_id not in sell_history else sell_history[card.card_id] + 1
		price += card.card_data.yield_gold + all_bonus[EResource.GOLD][card.business][EType.ADD]
	GameManager.gold += int(price * all_bonus[EResource.GOLD][ResourceCardData.EBusiness.ALL][EType.MULTIPLY]) + all_bonus[EResource.GOLD][ResourceCardData.EBusiness.ALL][EType.ADD] 
						

func cal_sell_score(sell_card:Array[Card]):	
	var _dict : Dictionary = {}
	var price = 0
	for card : ResourceCard in sell_card:
		price += card.card_data.yield_price + all_bonus[EResource.SCORE][card.business][EType.ADD] 
		
	var demand : int = 0
	for card : ResourceCard in sell_card:
		demand += card.card_data.yield_demand + all_bonus[EResource.DEMAND][card.business][EType.ADD] 

	GameManager.current_score += price * demand * all_bonus[EResource.SCORE][ResourceCardData.EBusiness.ALL][EType.MULTIPLY] + all_bonus[EResource.SCORE][ResourceCardData.EBusiness.ALL][EType.ADD]
