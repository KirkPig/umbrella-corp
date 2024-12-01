extends Control

@export var start_energy : int = 3
@export var start_max_hand : int = 5
@export var start_discard_energy : int = 3
@export var start_shop_refresh : int = 10
@export var max_contract : int = 8
@export var game_speed: int = 1

@export var start_deck: Array[int]
@export var start_resource_pool: Array[int]
@export var start_upgrade_pool: int

@export var start_business: Array[int]
@export var start_business_yield: Array[int]

@onready var s_game_end: CanvasLayer = $SGameEnd
@onready var s_ui_phone: CanvasLayer = $SUiPhone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	set_up_game_manager()
	clear_card_pool()
	add_card_pool()
	add_start_deck()
	add_start_business()
	GameManager.start_select_contract()
	s_game_end.start_resource_list = start_resource_pool

func set_up_game_manager() -> void:
	GameManager.current_turn = 0
	GameManager.total_turn = 0
	GameManager.current_score = 0
	GameManager.current_contract = 0
	GameManager.total_score = 0
	GameManager.gold = 0
	GameManager.energy = start_energy
	GameManager.max_energy = start_energy
	GameManager.max_hand = start_max_hand
	GameManager.discard_energy = start_discard_energy
	GameManager.max_discard_energy = start_discard_energy
	GameManager.shop_refresh = start_shop_refresh
	GameManager.max_shop_refresh = start_shop_refresh
	GameManager.max_contract = max_contract
	
	GameManager.phone_canvas = s_ui_phone
	
	GameManager.game_speed = game_speed
	
	GameManager.rng = RandomNumberGenerator.new()
	#GameManager.rng.seed = hash("0")

func clear_card_pool():
	CardManager.card_pool = []

func add_card_pool() -> void:
	for _id in start_resource_pool:
		CardManager.unlock_resource(_id)
	
	# TODO: new ways for add card pool
	for _id in range(6):
		CardManager.card_pool.append(_id)
	for _id in range(3000, 3018):
		CardManager.card_pool.append(_id)

func add_start_deck()-> void:
	for _id in start_deck:
		CardManager.add_card_to_deck(_id)
		
func add_start_business()-> void:
	for _id in start_business:
		CardManager.add_card_to_business_field(_id,2000)
