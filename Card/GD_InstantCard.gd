extends Card
class_name InstantCard


var card_data: InstantCardData:
	set(value):
		if card_data:
			card_data.changed.disconnect(set_data)
		value.changed.connect(set_data)
		card_data = value
		set_data(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func set_data(data: InstantCardData):
	set_base_data(data)
	
func activate() -> void:
	card_data.activate([])
