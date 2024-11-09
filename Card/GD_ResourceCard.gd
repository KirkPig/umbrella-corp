extends Card
class_name ResourceCard

var yield_score = 10
var yield_gold = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_data(data: ResourceCardData):
	set_base_data(data)
	yield_score = data.yield_score
	yield_gold = data.yield_gold
