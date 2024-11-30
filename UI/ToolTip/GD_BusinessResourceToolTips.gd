extends Control

@onready var keyword_icon: TextureRect = $IconContainer/Control/KeywordIcon
@onready var amount_label: Label = $IconContainer/AmountLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_resource(_id:int,amount:int) -> void:
	keyword_icon.texture = load("res://Assets/IconNoBG/A_ResourceIcon_"+str(_id)+".png")
	amount_label.text = "x"+str(amount)
	

func set_labor(amount:int)-> void:
	amount_label.text = "x"+str(amount)
