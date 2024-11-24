extends InstantEffect
class_name InstantEffectSellbonus

@export var effect_resource : SellManager.EResource
@export var effect_type : SellManager.EType
@export var effect_amount : float
@export var effect_time_type : SellManager.ETimesType
@export var effect_time : int
@export var effect_target : ResourceCardData.EBusiness

func activate(target:Array[Card]) -> void:
	var bonus_effect = SellBonusEffect.new()
	bonus_effect.start( 
		effect_type,
		effect_time,
		effect_time_type,
		effect_amount,
		effect_resource,
		effect_target)
	
