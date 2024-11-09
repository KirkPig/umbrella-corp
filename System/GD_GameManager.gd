extends Control

@export var start_energy : int = 3
@export var start_max_hand : int = 5

@export var start_deck: Array[ResourceBaseCard]
@export var start_business: Array[ResourceBusinessCard]

@onready var action_list = $ActionList
@onready var status_bar = $StatusBar

@onready var worker_card = preload("res://Card/Presets/S_Worker.tscn")
@onready var business_card = preload("res://Card/Presets/S_Business.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#action_list.btn_sell_pressed.connect(action_sell)
	#action_list.btn_discard_pressed.connect(action_discard)
	#action_list.btn_end_pressed.connect(end_turn)
	start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	set_up_game_manager()
	add_start_deck()
	GameManager.next_turn()

func set_up_game_manager() -> void:
	GameManager.current_turn = 1
	GameManager.total_turn = 1
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




## Section: Actions
#func action_work(business: BusinessCard):
	#var selected_card = get_selected_card()
	#
	## TODO: More on can not work if energy is not enough
	#if !action_list.can_work(selected_card, energy):
		#return
		#
	#for card in selected_card:
		#if card.is_selected:
			#var _res = business.gather_resource()
			#discarded.add_child(_res)
	#discards(selected_card)
	#fill_hand()
	#
	#energy = energy - action_list.energy_cost_work
	#action_list.reset_list()
	#
#func action_discard():
	#discards(get_selected_card())
	#fill_hand()
	#
	#energy = energy - action_list.energy_cost_discard
	#action_list.reset_list()
#
#func action_sell():
	#var selected_card: Array[Card] = get_selected_card()
	#var _dict : Dictionary = {}
	#var price = 0
	#for card : ResourceCard in selected_card:
		#if card.resource_id in _dict:
			#_dict[card.resource_id] += 1
		#else:
			#_dict[card.resource_id] = 1
		#price = price + card.point
		#gold = gold + card.gold
		#
	#var mul : int = 0
	#for val in _dict.values():
		#mul = maxi(mul, val)
	#
	#score = score + (mul * price)
	#played_cards(selected_card)
	#fill_hand()
	#
	#energy = energy - action_list.energy_cost_sell
	#action_list.reset_list()
#
#func action_buy(card: Card):
	#if card.shop_price > gold:
		#return
	#card.in_shop = false
	#gold = gold - card.shop_price
	#card.reparent(hand)
#
#func action_research():
	#pass
	
