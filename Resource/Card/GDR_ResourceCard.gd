extends CardData
class_name ResourceCardData

enum EBusiness{
	ALL,
	FARM,
	MINE,
	FORESTRY,
	SAND_FIELD,
	LIVESTOCK,
}

@export var business_id: int

@export_category("Resource yield")
@export var yield_price: int
@export var yield_demand: int
@export var labor_per_piece: int
@export var yield_gold: int
@export var yield_piece: int = 1
@export var components: Array[ResourceComponentItemData]

@export_category("Research")
@export var research_yield: Array[ResearchReward]

@export_category("Upgrade")
@export var upgrade_yield_amount: int = 1
@export var upgrade_yield_gold: int = 10
@export var upgrade_price_amount: int = 10
@export var upgrade_price_gold: int = 10
@export var upgrade_demand_amount: int = 1
@export var upgrade_demand_gold: int = 10

func get_business_card_data() -> BusinessCardData:
	return CardManager.card_dict[business_id]
