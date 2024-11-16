extends VBoxContainer
class_name ActionListController

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
	ActionManager.action_list = self
	reset_list()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_list(selected_card: Array[Card] ):
	show_sell = GameManager.can_sell(selected_card)
	show_discard = GameManager.can_discard(selected_card)
	
func reset_list():
	show_sell = false
	show_discard = false
	show_end = true

func _on_sell_button_pressed() -> void:
	ActionManager.action_sell()


func _on_discard_button_pressed() -> void:
	ActionManager.action_discard()


func _on_end_turn_button_pressed() -> void:
	GameManager.end_turn()
