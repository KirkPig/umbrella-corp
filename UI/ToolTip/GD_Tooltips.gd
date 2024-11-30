extends Control
class_name Tooptips

@onready var keyword_container: VBoxContainer = $HBoxContainer/KeywordContainer
@onready var labor_container: HBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/LaborContainer
@onready var resource_container: HBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ResourceContainer
@onready var effect_container: HBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/EffectContainer

@onready var labor_label: Label = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/LaborContainer/LaborLabel
@onready var price_label: Label = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ResourceContainer/PriceLabel
@onready var demand_label: Label = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ResourceContainer/DemandLabel
@onready var gold_label: Label = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ResourceContainer/GoldLabel
@onready var effect_label: Label = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/EffectContainer/EffectLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_labor(amount:int) -> void:
	var s_keyword = load("res://UI/ToolTip/S_ToolTipsKeyword.tscn")
	labor_container.visible = true
	labor_label.text = "x"+str(amount)
	var keyword_instance:ToolTipsKeyword = s_keyword.instantiate()
	keyword_container.add_child(keyword_instance)
	keyword_instance.set_keyword(ToolTipsKeyword.EKeyword.LABOR)

func set_resource(resource_id:int) -> void:
	resource_container.visible = true
	var card_data :ResourceCardData= CardManager.card_dict[resource_id]
	var price = card_data.yield_price + SellManager.card_sell_bonus[SellManager.EResource.SCORE][resource_id] \
		if resource_id in SellManager.card_sell_bonus[SellManager.EResource.SCORE] else card_data.yield_price 
	var demand = card_data.yield_demand + SellManager.card_sell_bonus[SellManager.EResource.DEMAND][resource_id] \
		if resource_id in SellManager.card_sell_bonus[SellManager.EResource.DEMAND] else card_data.yield_demand 
	var gold = card_data.yield_gold + SellManager.card_sell_bonus[SellManager.EResource.GOLD][resource_id] \
		if resource_id in SellManager.card_sell_bonus[SellManager.EResource.GOLD] else card_data.yield_gold 
	price_label.text = str(price)
	demand_label.text = str(demand)
	gold_label.text = str(gold)

func set_effect(effect:String) -> void:
	effect_container.visible = true
	effect_label.text = effect
	
func set_keywords(keyword_list:Array[ToolTipsKeyword.EKeyword])-> void:
	var s_keyword = load("res://UI/ToolTip/S_ToolTipsKeyword.tscn")
	for keyword in keyword_list:
		var keyword_instance:ToolTipsKeyword = s_keyword.instantiate()
		keyword_container.add_child(keyword_instance)
		keyword_instance.set_keyword(keyword)
		
