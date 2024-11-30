extends Card
class_name BusinessCard

signal selected_work(card: BusinessCard)

var card_data: BusinessCardData:
	set(value):
		if card_data:
			card_data.changed.disconnect(set_data)
		value.changed.connect(set_data)
		card_data = value
		set_data(value)

var max_usage : int
var resource_yield_list : Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func selected():
	if in_shop:
		emit_signal("is_buy", self)
		return
	emit_signal("selected_work", self)

func set_data(data: BusinessCardData):
	set_base_data(data)
	max_usage = data.max_usage
	resource_yield_list = data.resource_yield_list
