extends Control

@export var start_energy : int = 3
@export var start_max_hand : int = 5
@export var start_discard_energy : int = 3
@export var start_shop_refresh : int = 10

@export var start_deck: Array[int]
@export var start_resource_pool: Array[int]

@export var start_business: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	set_up_game_manager()
	add_card_pool()
	add_start_deck()
	add_start_business()
	GameManager.start_select_contract()

func set_up_game_manager() -> void:
	GameManager.current_turn = 0
	GameManager.total_turn = 0
	GameManager.current_score = 0
	GameManager.total_score = 0
	GameManager.gold = 0
	GameManager.energy = start_energy
	GameManager.max_energy = start_energy
	GameManager.max_hand = start_max_hand
	GameManager.discard_energy = start_discard_energy
	GameManager.max_discard_energy = start_discard_energy
	GameManager.shop_refresh = start_shop_refresh
	GameManager.max_shop_refresh = start_shop_refresh
	
	GameManager.rng = RandomNumberGenerator.new()
	GameManager.rng.seed = hash("0")

func add_card_pool() -> void:
	for _id in start_resource_pool:
		CardManager.unlock_resource(_id)

func add_start_deck()-> void:
	for res_card in start_deck:
		CardManager.add_card_to_deck(res_card)
		
func add_start_business()-> void:
	for res_card in start_business:
		CardManager.add_card_to_field(res_card)
