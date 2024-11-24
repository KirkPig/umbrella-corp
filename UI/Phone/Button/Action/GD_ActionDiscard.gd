extends TextureButton

@onready var action_discard_label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_discard_energy_change.connect(_on_current_discard_energy_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_current_discard_energy_change(energy:int) -> void:
	action_discard_label.text = "Discard ("+str(energy) +")"
