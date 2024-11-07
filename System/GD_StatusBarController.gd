extends VBoxContainer
class_name StatusBarController

@onready var turn_value_label = $Turn/Value
@onready var score_value_label = $Score/Value
@onready var gold_value_label = $Gold/Value
@onready var energy_value_label = $Energy/Value
@onready var max_energy_value_label = $Energy/Max

var turn : int:
	set(value):
		turn = value
		turn_value_label.text = String.num_int64(value)
var score : int:
	set(value):
		score = value
		score_value_label.text = String.num_int64(value)
var gold : int:
	set(value):
		gold = value
		gold_value_label.text = String.num_int64(value)
var energy : int:
	set(value):
		energy = value
		energy_value_label.text = String.num_int64(value)
var max_energy : int:
	set(value):
		max_energy = value
		max_energy_value_label.text = String.num_int64(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
