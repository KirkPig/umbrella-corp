extends Resource
class_name ResearchReward

@export var another_resource: ResourceCardData
@export var priority: int
@export var chance: int

func can_activate(_resource: ResourceCardData) -> bool:
	return true

func activate() -> void:
	pass
