extends Node
class_name Contract

@export var contract_res: ResourceContract

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contract_res.name
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#TODO: when selected
func selectd() -> void:
	pass

# TODO:check id score pass
func check_finish_contract() -> bool:
	return false
