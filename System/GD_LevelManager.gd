extends Control

@export var start_energy : int = 3
@export var start_max_hand : int = 5

@export var start_deck: Array[CardData]
@export var start_business: Array[BusinessCardData]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	set_up_game_manager()
	add_start_deck()
	add_start_business()

func set_up_game_manager() -> void:
	GameManager.current_turn = 0
	GameManager.total_turn = 0
	GameManager.current_score = 0
	GameManager.total_score = 0
	GameManager.gold = 0
	GameManager.max_energy = start_energy
	GameManager.energy = start_energy
	GameManager.max_hand = start_max_hand
	
func add_start_deck()-> void:
	for res_card in start_deck:
		CardManager.add_card_to_deck(res_card)
		
func add_start_business()-> void:
	for res_card in start_business:
		CardManager.added_business_field(res_card)
