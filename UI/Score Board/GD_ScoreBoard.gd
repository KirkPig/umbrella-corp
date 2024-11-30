extends VBoxContainer

@onready var turn_value_label = $HBoxContainer/TextureRect/VBoxContainer/Label
@onready var current_contract_label = $HBoxContainer/TextureRect2/VBoxContainer2/Control/HBoxContainer/Label
@onready var max_contract_label = $HBoxContainer/TextureRect2/VBoxContainer2/Control/HBoxContainer/Control/Label3
@onready var score_value_label = $HBoxContainer/TextureRect3/VBoxContainer3/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.scoreboard = self
	GameManager.current_turn_change.connect(turn_changed)
	GameManager.current_score_change.connect(score_changed)
	GameManager.current_contract_change.connect(current_contract_change)
	GameManager.max_contract_change.connect(max_contract_changed)

func turn_changed(value:int) ->void:
	turn_value_label.text = String.num_int64(value)
	
func current_contract_change(value:int) ->void:
	current_contract_label.text = String.num_int64(value)
	
func max_contract_changed(value:int) ->void:
	max_contract_label.text = String.num_int64(value)
	
func score_changed(value:int) ->void:
	score_value_label.text = String.num_int64(value)
