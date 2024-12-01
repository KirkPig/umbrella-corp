extends Control
var card_id = 0
@onready var icon_rec = $SCardIcon/IconRec
@onready var icon_label =$SCardIcon/Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func load_icons(id: int,amount:int) -> void:
	card_id = id
	var icon_texture:Texture2D
	if id >= 2000 and id < 3000:
		icon_texture = load("res://Assets/Icon/A_ResourceIcon_"+str(id)+".png")
	if id >= 3000 and id < 4000:
		icon_texture = load("res://Assets/InstantIcon/A_InstantIcon_"+str(id)+".png")
	if id < 1000:
		icon_texture = load("res://Assets/WorkerIcon/A_WorkerIcon_"+str(10000+id).substr(1, 4)+".png")
	icon_rec.texture = icon_texture
	icon_label.text = str(amount)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
