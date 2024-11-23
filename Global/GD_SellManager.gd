extends Node

enum ETimesType{
	times,
	turn
}
enum EResource{
	sell_score,
	sell_gold,
	price,
	demand
}
enum EType{
	multiply,
	add,
	Set,
	addEach
}
var bonus_effect_list :Array[SellBonusEffect]= []
var all_bonus = {
	EResource.sell_score:{
		EType.multiply: 1,
		EType.add: 0,
		EType.addEach: 0,
		EType.Set:0,
		'is_set':false
	},
	EResource.sell_gold:{
		EType.multiply: 1,
		EType.add: 0,
		EType.addEach: 0,
		EType.Set:0,
		'is_set':false
	},
	EResource.price:{
	},
	EResource.demand:{
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
		price += card.yield_score + all_bonus[EResource.sell_gold][EType.addEach] 
	GameManager.gold += all_bonus[EResource.sell_gold][EType.Set]  \
						if all_bonus[EResource.sell_gold]['is_set'] else \
						int(price * all_bonus[EResource.sell_gold][EType.multiply]) + all_bonus[EResource.sell_gold][EType.add] 
						

func cal_sell_score(sell_card:Array[Card]):	
	var _dict : Dictionary = {}
	var price = 0
	for card : ResourceCard in sell_card:
		if card.card_id in _dict:
			_dict[card.card_id] += 1
		else:
			_dict[card.card_id] = 1
		price = price + card.yield_score + all_bonus[EResource.sell_score][EType.addEach] 
		
	var mul : int = 0
	for val in _dict.values():
		mul = maxi(mul, val)

	GameManager.current_score += all_bonus[EResource.sell_score][EType.Set]  \
						if all_bonus[EResource.sell_score]['is_set'] else \
						(mul * price) * all_bonus[EResource.sell_score][EType.multiply] + all_bonus[EResource.sell_gold][EType.add]
