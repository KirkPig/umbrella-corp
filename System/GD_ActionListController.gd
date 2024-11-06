extends VBoxContainer
class_name ActionListController

signal btn_sell_pressed
signal btn_discard_pressed
signal btn_end_pressed

@onready var btn_sell = $SellButton
@onready var btn_discard = $DiscardButton
@onready var btn_end = $EndTurnButton

var show_sell : bool:
	set(value):
		show_sell = value
		btn_sell.visible = value
var show_discard : bool:
	set(value):
		show_discard = value
		btn_discard.visible = value
var show_end : bool:
	set(value):
		show_end = value
		btn_end.visible = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#btn_working.hide()
	show_sell = false
	show_discard = false
	show_end = true
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var energy_cost_sell: int = 1
var energy_cost_discard: int = 0
var energy_cost_work: int = 1

func can_sell(selected_card: Array[Card], energy: int) -> bool:
	if selected_card.size() <= 0:
		return false
	if energy < energy_cost_sell:
		return false
	for card in selected_card:
		if card is not ResourceCard:
			return false
	return true

func can_discard(selected_card: Array[Card], energy: int) -> bool:
	if selected_card.size() <= 0:
		return false
	if energy < energy_cost_discard:
		return false
	return true

func can_work(selected_card: Array[Card], energy: int) -> bool:
	if selected_card.size() <= 0:
		return false
	if energy < energy_cost_work:
		return false
	for card in selected_card:
		if card is not WorkerCard:
			return false
	return true
	
func update_list(selected_card: Array[Card], energy: int):
	show_sell = can_sell(selected_card, energy)
	show_discard = can_discard(selected_card, energy)

func _on_sell_button_pressed() -> void:
	emit_signal("btn_sell_pressed")
	pass # Replace with function body.


func _on_discard_button_pressed() -> void:
	emit_signal("btn_discard_pressed")
	pass # Replace with function body.


func _on_end_turn_button_pressed() -> void:
	emit_signal("btn_end_pressed")
	pass # Replace with function body.
