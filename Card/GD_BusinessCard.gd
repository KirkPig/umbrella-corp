extends Card
class_name BusinessCard


signal selected_work(card: BusinessCard)

@onready var yield_icon: TextureRect = $Card/YieldIcon
@onready var labor_label: Label = $Card/LaborLabel

var card_data: BusinessCardData:
	set(value):
		if card_data:
			card_data.changed.disconnect(refresh_data)
		value.changed.connect(refresh_data)
		card_data = value
		set_data(value)

var max_usage : int
var resource_yield_list : Array[int]
var current_yield_id : int
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
	current_yield_id = resource_yield_list[GameManager.rng.randi() % resource_yield_list.size()]
	yield_icon.texture = load("res://Assets/Icon/A_ResourceIcon_"+str(current_yield_id)+".png")
	var card_data:ResourceCardData = CardManager.card_dict[current_yield_id]
	labor_label.text = str(card_data.labor_per_piece)
	s_tooltips.set_business(current_yield_id)

func refresh_data():
	set_base_data(card_data)
	max_usage = card_data.max_usage
	resource_yield_list = card_data.resource_yield_list
	s_tooltips.set_business(current_yield_id)
