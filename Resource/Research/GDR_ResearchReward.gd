extends Resource
class_name ResearchReward

@export var another_resource_id: int
@export var priority: int
@export var chance: int

func can_activate(_resource: int) -> bool:
	return another_resource_id == -1 or _resource == another_resource_id

func activate() -> void:
	pass
