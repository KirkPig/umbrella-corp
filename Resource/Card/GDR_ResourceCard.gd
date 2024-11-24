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

@export var demand: int
@export var yield_score: int
@export var yield_gold: int
@export var business: EBusiness
@export var research_yield: Array[ResearchReward]
