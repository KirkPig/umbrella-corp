extends Resource
class_name ResearchReward

@export var need_resource: int
@export var priority: int
@export var chance: int

func can_activate(_resource: int) -> bool:
	return need_resource == -1 or _resource == need_resource

func activate() -> void:
	pass
