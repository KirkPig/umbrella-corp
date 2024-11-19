extends InstantEffect
class_name InstantEffectResource

enum EEffectType{
	gain,
	loss
}
enum EEffectResource{
	gold,
	energy,
	score,
	goal_score,
	goal_turn
}
@export var effect_type : EEffectType
@export var effect_resource : EEffectResource
@export var amount : int


func activate(target:Array[Card]) -> void:
	var effect_amount : int = 0
	match EEffectType:
		EEffectType.gain:
			effect_amount = amount
		EEffectType.loss:
			effect_amount = -amount
	
	match effect_resource:
		EEffectResource.gold:
			GameManager.gold += effect_amount
					
		EEffectResource.energy:
			GameManager.energy += amount
					
		EEffectResource.score:
			GameManager.current_score += amount
					
		EEffectResource.goal_score:
			GameManager.goal_score += amount
					
		EEffectResource.goal_turn:
			GameManager.goal_turn += amount
