extends Control
class_name Tooptips

@onready var keyword_container: VBoxContainer = $HBoxContainer/KeywordContainer
@onready var labor_container: HBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/LaborContainer
@onready var resource_container: HBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ResourceContainer
@onready var effect_container: HBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/EffectContainer

@onready var business_cost_container: HBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/BusinessCostContainer
@onready var texture_rect: TextureRect = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/TextureRect
@onready var business_yeild_container: HBoxContainer = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/BusinessCostYeildContainer

@onready var labor_label: Label = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/LaborContainer/LaborLabel
@onready var price_label: Label = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ResourceContainer/PriceLabel
@onready var demand_label: Label = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ResourceContainer/DemandLabel
@onready var gold_label: Label = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/ResourceContainer/GoldLabel
@onready var effect_label: Label = $HBoxContainer/PanelContainer/MarginContainer/VBoxContainer/EffectContainer/EffectLabel

var resource_keyword_dict :Dictionary ={}

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
		
func set_business(resource_id:int)-> void:
	var s_keyword = load("res://UI/ToolTip/S_ToolTipsKeyword.tscn")
	var s_business_resoruce = load("res://UI/ToolTip/S_BusinessResourceToolTips.tscn")
	var keyword_instance:ToolTipsKeyword = s_keyword.instantiate()
	keyword_container.add_child(keyword_instance)
	keyword_instance.set_keyword(ToolTipsKeyword.EKeyword.LABOR)
	var card_data:ResourceCardData = CardManager.card_dict[resource_id]
	var resooure_use_list = card_data.components
	for resooure_use in resooure_use_list:
		var s_business_resoruce_instance = s_business_resoruce.instantiate()
		business_cost_container.add_child(s_business_resoruce_instance)
		s_business_resoruce_instance.set_resource(resooure_use.resource_id,resooure_use.amount)
		set_keywors_resource(resooure_use.resource_id)
	
	var s_business_resoruce_labor_instance = s_business_resoruce.instantiate()
	business_cost_container.add_child(s_business_resoruce_labor_instance)
	s_business_resoruce_labor_instance.set_labor(card_data.labor_per_piece)
	
	var s_business_resoruce_yield_instance = s_business_resoruce.instantiate()
	business_yeild_container.add_child(s_business_resoruce_yield_instance)
	s_business_resoruce_yield_instance.set_resource(resource_id,1)
	set_keywors_resource(resource_id)
	
	business_cost_container.visible = true
	texture_rect.visible = true
	business_yeild_container.visible = true
	
func set_keywors_resource(resource_id:int):
	var s_keyword = load("res://UI/ToolTip/S_ToolTipsKeyword.tscn")
	if resource_id not in resource_keyword_dict:
		var keyword_instance:ToolTipsKeyword = s_keyword.instantiate()
		keyword_container.add_child(keyword_instance)
		keyword_instance.set_resource(resource_id)
		resource_keyword_dict[resource_id] = keyword_instance
	else:
		resource_keyword_dict[resource_id].set_resource(resource_id)
			
