extends Card
class_name WorkerCard

var card_data: WorkerCardData:
	set(value):
		if card_data:
			card_data.changed.disconnect(set_data)
		value.changed.connect(set_data)
		card_data = value
		set_data(value)

var base_work_rate : int
var special_work_rate : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func set_data(data: WorkerCardData):
	set_base_data(data)
	base_work_rate = data.base_work_rate
	special_work_rate = data.special_work_rate

# TODO: Spacial work rate (need to ask who do this)
func yield_labor_value(business: UIBusiness):
	return base_work_rate
