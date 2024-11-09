extends Card
class_name BusinessCard

signal selected_work(card: BusinessCard)

@onready var resource_card = preload("res://Card/Presets/S_Resource.tscn")

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
