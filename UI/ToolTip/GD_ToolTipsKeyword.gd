extends PanelContainer

enum EKeyword{
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

func set_labor():
	keyword_icon.texture = load("res://Assets/Tooltip/Labor.png")
	keyword_label.text = "Labor"
	description_label.text = "yield from worker card"
	description_label.visible = true
	s_gold_score.visible = false
			
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
		EKeyword.ENERGY:
			pass
