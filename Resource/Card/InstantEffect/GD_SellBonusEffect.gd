class_name SellBonusEffect

var type : SellManager.EType
var times :int
var times_type:SellManager.ETimesType
var amount: float
var resource : SellManager.EResource
var target: ResourceCardData

func start(_type : SellManager.EType, \
	_times :int, \
	_times_type:SellManager.ETimesType, \
	_amount: float, \
	_resource : SellManager.EResource,
	_target : ResourceCardData.EBusiness) -> void:
	type = _type
	times = _times
	times_type = _times_type
	amount = _amount
	resource = _resource
	target= target
	
	match type:
		SellManager.EType.MULTIPLY:
			SellManager.all_bonus[resource][target][type] *= amount
		SellManager.EType.ADD:
			SellManager.all_bonus[resource][target][type] += amount
			
	SellManager.bonus_effect_list.append(self)
	
func end() -> void:
	match type:
		SellManager.EType.MULTIPLY:
			SellManager.all_bonus[resource][target][type] /= amount
		SellManager.EType.ADD:
			SellManager.all_bonus[resource][target][type] -= amount
	
	SellManager.bonus_effect_list.erase(self)

func sell()-> void:
	if times_type == SellManager.ETimesType.TIMES:
		times -= 1
	
	if times == 0:
		end()
			
func end_turn()-> void:
	if times_type == SellManager.ETimesType.TURN:
		times -= 1
	
	if times == 0:
		end()
	
