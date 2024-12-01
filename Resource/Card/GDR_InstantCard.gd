extends CardData
class_name InstantCardData


@export var destroy_self:bool = false
@export_range(0,100,1) var destroy_chance:int = 0
@export var effects:Array[InstantEffect]

func played() -> void:
	activate([])
	
func activate(target:Array[Card]) -> void:
	for effect in effects:
		effect.activate(target)
