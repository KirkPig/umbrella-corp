extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CardManager.field = self
	
func get_all_card() -> Array[Node]:
	return self.get_children()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
