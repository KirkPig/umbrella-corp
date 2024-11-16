extends CardData
class_name InstantCardData

enum ETargetMode{
	None,
	Select,
	SelectType
}
enum ETargetType{
	None,
	Hand,
	Business,
	Discard,
	Shop
}
@export var target_mode:ETargetMode = ETargetMode.None 
@export var target_type:ETargetType = ETargetType.None
@export var effects:Array[InstantEffect]

func played() -> void:
	match target_mode:
		ETargetMode.None:
			activate([])
			
			
func activate(target:Array[Card]) -> void:
	for effect in effects:
		effect.activate(target)
