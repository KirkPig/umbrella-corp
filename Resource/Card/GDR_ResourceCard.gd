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

func get_business_card_data() -> BusinessCardData:
	return CardManager.card_dict[business_id]
