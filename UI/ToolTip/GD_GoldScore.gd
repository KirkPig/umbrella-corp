extends HBoxContainer

@onready var price_label: Label = $PriceLabel
@onready var demand_label: Label = $DemandLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func set_resource_data(resource_id:int) -> void:
	var card_data :ResourceCardData= CardManager.card_dict[resource_id]
	var price = card_data.yield_price + SellManager.card_sell_bonus[SellManager.EResource.SCORE][resource_id] \
		if resource_id in SellManager.card_sell_bonus[SellManager.EResource.SCORE] else card_data.yield_price 
	var demand = card_data.yield_demand + SellManager.card_sell_bonus[SellManager.EResource.DEMAND][resource_id] \
		if resource_id in SellManager.card_sell_bonus[SellManager.EResource.DEMAND] else card_data.yield_price 
	price_label.text = str(price)
	demand_label.text = demand
