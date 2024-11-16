class_name SellBonusEffect

var type : SellManager.EType
var times :int
var times_type:SellManager.ETimesType
var amount: float
var resource : SellManager.EResource

func start(_type : SellManager.EType, \
	_times :int, \
	_times_type:SellManager.ETimesType, \
	_amount: float, \
	_resource : SellManager.EResource) -> void:
	type = _type
	times = _times
	times_type = _times_type
	amount = _amount
	resource = _resource
	
	match type:
		SellManager.EType.multiply:
			SellManager.all_bonus[resource][type] *= amount
		SellManager.EType.add, \
		SellManager.EType.addEach:
			SellManager.all_bonus[resource][type] += amount
		SellManager.EType.Set:
			SellManager.all_bonus[resource][type] += amount
			SellManager.all_bonus[resource]['is_set'] = false
			
	SellManager.bonus_effect_list.append(self)
	
func end() -> void:
	match type:
		SellManager.EType.multiply:
			SellManager.all_bonus[resource][type] /= amount
		SellManager.EType.add, \
		SellManager.EType.addEach:
			SellManager.all_bonus[resource][type] -= amount
		SellManager.EType.Set:
			SellManager.all_bonus[resource][type] -= amount
			SellManager.all_bonus[resource]['is_set'] = false
	
	SellManager.bonus_effect_list.erase(self)

func sell()-> void:
	if times_type == SellManager.ETimesType.times:
		times -= 1
	
	if times == 0:
		end()
			
func end_turn()-> void:
	if times_type == SellManager.ETimesType.turn:
		times -= 1
	
	if times == 0:
		end()
	
