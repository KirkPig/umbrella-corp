extends Control
class_name ContractUI

@onready var label_deadline = $Description/Deadline/Container/Value
@onready var label_target = $Description/Target/Container/Value

var deadline = 7:
	set(value):
		deadline = value
		label_deadline.text = str(value)
var target = 650:
	set(value):
		target = value
		label_target.text = str(value)

func set_data(data: ResourceContract):
	deadline = data.turn_limit
	target = data.score_goal
	pass
