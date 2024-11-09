extends VBoxContainer
class_name StatusBarController

@onready var turn_value_label = $Turn/Value
@onready var goal_turn_value_label = $Turn/Max
@onready var score_value_label = $Score/Value
@onready var goal_score_value_label = $Score/Max
@onready var total_score_value_label = $TotalScore/Value
@onready var gold_value_label = $Gold/Value
@onready var energy_value_label = $Energy/Value
@onready var max_energy_value_label = $Energy/Max

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_turn_change.connect(turn_changed)
	GameManager.current_score_change.connect(score_changed)
	GameManager.gold_change.connect(gold_changed)
	GameManager.current_energy_change.connect(energy_changed)
	GameManager.max_energy_change.connect(max_energy_changed)
	GameManager.goal_turn_change.connect(goal_turn_changed)
	GameManager.goal_score_change.connect(goal_score_changed)
	GameManager.total_score_change.connect(total_score_changed)

func turn_changed(value:int) ->void:
	turn_value_label.text = String.num_int64(value)
	
func goal_turn_changed(value:int) ->void:
	goal_turn_value_label.text = String.num_int64(value)
	
func score_changed(value:int) ->void:
	score_value_label.text = String.num_int64(value)

func goal_score_changed(value:int) ->void:
	goal_score_value_label.text = String.num_int64(value)
	
func total_score_changed(value:int) ->void:
	total_score_value_label.text = String.num_int64(value)
	
func gold_changed(value:int) ->void:
	gold_value_label.text = String.num_int64(value)
	
func energy_changed(value:int) ->void:
	energy_value_label.text = String.num_int64(value)

func max_energy_changed(value:int) ->void:
	max_energy_value_label.text = String.num_int64(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
