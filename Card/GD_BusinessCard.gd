extends Card
class_name BusinessCard

signal selected_work(card: BusinessCard)

@onready var resource_card = preload("res://Card/Presets/S_Resource.tscn")

var worker_usage : int
var resource_return : int
var max_usage : int
var resource_yield_list : Array[ResourceCardData]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func selected():
	emit_signal("selected_work", self)

func gather_resource():
	var card = resource_card.instantiate()
	return card

func set_data(data: BusinessCardData):
	set_base_data(data)
	worker_usage = data.worker_usage
	resource_return = data.resource_return
	max_usage = data.max_usage
	resource_yield_list = data.resource_yield_list
