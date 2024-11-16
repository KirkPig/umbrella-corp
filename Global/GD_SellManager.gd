extends Node

enum ETimesType{
	times,
	turn
}
enum EResource{
	sell_score,
	sell_gold,
}
enum EType{
	multiply,
	add,
	Set
}
var bonus_effect_list :Array[SellBonusEffect]= []
var all_bonus = {
	EResource.sell_score:{
		EType.multiply: 1,
		EType.Set:0,
		'is_set':false
	},
	EResource.sell_gold:{
		EType.multiply: 1,
		EType.Set:0,
		'is_set':false
	}
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
		price = price + card.yield_score
	GameManager.gold += int(price * all_bonus[EResource.sell_gold][EType.multiply]) \
						if all_bonus[EResource.sell_gold]['is_set'] else \
						all_bonus[EResource.sell_gold][EType.Set]
						

func cal_sell_score(sell_card:Array[Card]):	
	var _dict : Dictionary = {}
	var price = 0
	for card : ResourceCard in sell_card:
		if card.card_id in _dict:
			_dict[card.card_id] += 1
		else:
			_dict[card.card_id] = 1
		price = price + card.yield_score
		
	var mul : int = 0
	for val in _dict.values():
		mul = maxi(mul, val)

	GameManager.current_score += (mul * price) * all_bonus[EResource.sell_score][EType.multiply] \
						if all_bonus[EResource.sell_score]['is_set'] else \
						all_bonus[EResource.sell_score][EType.Set]
