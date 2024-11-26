extends CanvasLayer

signal close_view

@export var card_gap: float = 100
@export var hand_width: float = 1328
@export var card_icon = preload("res://UI/Phone/Pile/S_CardIcon.tscn")
@onready var icon_grid = $Panel/Panel/HSplitContainer/LeftControl/VBoxContainer/Control3/GridContainer
@onready var worker_pile = $Panel/Panel/HSplitContainer/Control/WorkerPile
@onready var resource_pile = $Panel/Panel/HSplitContainer/Control/ResourcePile
@onready var instant_pile = $Panel/Panel/HSplitContainer/Control/InstantPile

var card_dict:Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	for icon in icon_grid.get_children():
		icon.queue_free()
	close_view.emit() 


func move_card_to_pile(card_list:Array[Node]) -> void:
	card_dict = {}
	for card in card_list:
		card_dict[card.card_id] = 1 if card.card_id not in card_dict else card_dict[card.card_id] + 1
		if card is WorkerCard:
			card.reparent(worker_pile)
			update_position(worker_pile)
		if card is ResourceCard:
			card.reparent(resource_pile)
			update_position(resource_pile)
		if card is InstantCard:
			card.reparent(instant_pile)
			update_position(instant_pile)
	
	for card_id in card_dict:
		var s_icon = card_icon.instantiate()
		icon_grid.add_child(s_icon)
		s_icon.load_icons(card_id,card_dict[card_id])


func update_position(pile:Control):
	var cards = pile.get_children()
	var i = 0
	cards.sort_custom(_compare_card)
	for card: Card in cards:
		card.set_card_pile_position(i,card_gap)
		i+=1

func _compare_card(a: Card, b: Card) -> bool:
	return a.card_id < b.card_id

func get_all_card() -> Array[Card]:
	var card_list: Array[Card]= []
	card_list.append_array(worker_pile.get_children())
	card_list.append_array(resource_pile.get_children())
	card_list.append_array(instant_pile.get_children())
	return card_list
