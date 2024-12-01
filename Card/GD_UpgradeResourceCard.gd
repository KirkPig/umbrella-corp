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
	var upgrade_resource_type:UpgradeCardData.EUpgradeResource
	match data.upgrade_type:
		UpgradeCardData.EUpgrade.RESOURE_DEMAND:
			upgrade_resource_type = UpgradeCardData.EUpgradeResource.RESOURE_DEMAND
		UpgradeCardData.EUpgrade.RESOURE_SCORE:
			upgrade_resource_type = UpgradeCardData.EUpgradeResource.RESOURE_SCORE
		UpgradeCardData.EUpgrade.RESOURE_YEILD:
			upgrade_resource_type = UpgradeCardData.EUpgradeResource.RESOURE_YEILD
	
	s_tooltips.set_upgrade_resource(data.upgrade_resoruce_id,upgrade_resource_type,data.upgrade_amount)

func refresh_data():
	set_base_data(card_data)
	if len(card_data.keyword_list) > 0:
		s_tooltips.set_keywords(card_data.keyword_list)
	if card_data.Effect != "":
		s_tooltips.set_effect(card_data.Effect)
