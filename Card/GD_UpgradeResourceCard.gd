extends UpgradeCard
class_name UpgradeResourceCard

@onready var icons: Control = $Card/Icons


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func set_data(data: UpgradeCardData):
	set_base_data(data)
	for icon_rec in icons.get_children():
		icon_rec.texture = card_data.upgrade_resoruce_icon
