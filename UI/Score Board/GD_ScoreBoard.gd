extends VBoxContainer

@onready var total_turn_value_label = $HBoxContainer/TextureRect/VBoxContainer/Label
@onready var turn_value_label = $HBoxContainer/TextureRect2/VBoxContainer2/Control/HBoxContainer/Label
@onready var goal_turn_value_label = $HBoxContainer/TextureRect2/VBoxContainer2/Control/HBoxContainer/Control/Label3
@onready var score_value_label = $HBoxContainer/TextureRect3/VBoxContainer3/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_turn_change.connect(turn_changed)
	GameManager.total_turn_change.connect(total_turn_changed)
	GameManager.current_score_change.connect(score_changed)
	GameManager.goal_turn_change.connect(goal_turn_changed)

func turn_changed(value:int) ->void:
	turn_value_label.text = String.num_int64(value)
	
func total_turn_changed(value:int) ->void:
	total_turn_value_label.text = String.num_int64(value)
	
func goal_turn_changed(value:int) ->void:
	goal_turn_value_label.text = String.num_int64(value)
	
func score_changed(value:int) ->void:
	score_value_label.text = String.num_int64(value)
