extends PanelContainer
class_name ToolTipsKeyword

enum EKeyword{
	LABOR,
	ENERGY,
	DEMAND,
	TURN,
	CARD_TO_HAND,
	INC_PRICE,
	DEC_PRICE,
	CHANGE_CARD,
	DESTROY_CARD,
	RESTRICT,
	YEILD,
	SHOP_REFRESH,
	MAX_HAND,
	MAX_DISCARD,
}

var resource_id:int = -1

@onready var keyword_icon: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/KeywordIcon
@onready var keyword_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/KeywordLabel
@onready var description_label: Label = $MarginContainer/VBoxContainer/DescriptionLabel
@onready var s_gold_score: HBoxContainer = $MarginContainer/VBoxContainer/SGoldScore


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_resource(resource_id:int)->void:
	var card_data :ResourceCardData= CardManager.card_dict[resource_id]
	keyword_icon.texture = load("res://Assets/Icon/A_ResourceIcon_"+str(resource_id)+".png")
	keyword_label.text = card_data.card_name
	description_label.visible = false
	s_gold_score.visible = true
	s_gold_score.set_resource_data(resource_id)
	
func set_keyword(keyword:EKeyword) -> void:
	description_label.visible = false
	s_gold_score.visible = false
	match(keyword):
		EKeyword.LABOR:
			keyword_icon.texture = load("res://Assets/Tooltip/Labor.png")
			keyword_label.text = "Labor"
			description_label.text = "yield from worker card"
			description_label.visible = true
		EKeyword.ENERGY:
			keyword_label.text = "Energy"
			keyword_icon.texture = load("res://Assets/InstantEffectIcon/A_increaseenergy.png")
		EKeyword.DEMAND:
			keyword_label.text = "Demand"
			keyword_icon.texture = load("res://Assets/InstantEffectIcon/A_increasedemand.png")
		EKeyword.TURN:
			keyword_label.text = "Turn"
			keyword_icon.texture = load("res://Assets/InstantEffectIcon/A_increaseturn.png")
		EKeyword.CARD_TO_HAND:
			keyword_label.text = "Add card to your hand"
			keyword_icon.texture = load("res://Assets/InstantEffectIcon/A_increasecard.png")
		EKeyword.INC_PRICE:
			keyword_label.text = "Price"
			keyword_icon.texture = load("res://Assets/InstantEffectIcon/A_increaseprice.png")
		EKeyword.DEC_PRICE:
			keyword_label.text = "Decrease price"
			keyword_icon.texture = load("res://Assets/InstantEffectIcon/A_decreaseprice.png")
		EKeyword.CHANGE_CARD:
			keyword_label.text = "Change card"
			keyword_icon.texture = load("res://Assets/InstantEffectIcon/A_changecard.png")
		EKeyword.DESTROY_CARD:
			keyword_label.text = "Destroy card"
			keyword_icon.texture = load("res://Assets/InstantEffectIcon/A_destroycard.png")
		EKeyword.RESTRICT:
			keyword_label.text = "Restrict"
			keyword_icon.texture = load("res://Assets/InstantEffectIcon/A_restrictcard.png")
		EKeyword.SHOP_REFRESH:
			keyword_label.text = "Shop refresh"
			keyword_icon.texture = load("res://Assets/UpgradeEffectIcon/A_refresh.png")
		EKeyword.MAX_HAND:
			keyword_label.text = "Max card in hand"
			keyword_icon.texture = load("res://Assets/UpgradeEffectIcon/A_maxCard.png")
		EKeyword.MAX_DISCARD:
			keyword_label.text = "Max Discard"
			keyword_icon.texture = load("res://Assets/UpgradeEffectIcon/A_maxDiscard.png")
