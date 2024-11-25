extends Card
class_name ResourceCard

var card_data: ResourceCardData:
	set(value):
		if card_data:
			card_data.changed.disconnect(set_data)
		value.changed.connect(set_data)
		card_data = value
		set_data(value)

var yield_score = 10
var yield_gold = 1
var business = 0
var demand = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func set_data(data: ResourceCardData):
	set_base_data(data)
	yield_score = data.yield_score
	yield_gold = data.yield_gold
	business = data.business
	demand = data.demand
