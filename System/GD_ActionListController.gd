extends VBoxContainer
class_name ActionListController

@onready var btn_action = $ActionButton
@onready var btn_discard = $DiscardButton
@onready var btn_label = $ActionButton/Label
enum EAction{
	sell,
	activate,
	research,
	end_turn
}

var action_mode : EAction:
	set(value):
		action_mode = value
		match value:
			EAction.sell:
				btn_label.text = 'SELL'
				btn_label.position.x = 100
			EAction.activate:
				btn_label.text = 'ACTIVATE'
				btn_label.position.x = 80
			EAction.research:
				btn_label.text = 'RESEARCH'
				btn_label.position.x = 80
			EAction.end_turn:
				btn_label.text = 'END TURN'
				btn_label.position.x = 80

var show_discard : bool:
	set(value):
		show_discard = value
		btn_discard.visible = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ActionManager.action_list = self
	reset_list()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_list(selected_card: Array[Card] ):
	action_mode = EAction.end_turn
	if GameManager.can_sell(selected_card):
		action_mode = EAction.sell
	if GameManager.can_research(selected_card):
		action_mode = EAction.research
	if GameManager.can_activate(selected_card):
		action_mode = EAction.activate
	show_discard = GameManager.can_discard(selected_card)
	
func reset_list():
	action_mode = EAction.end_turn

func _on_sell_button_pressed() -> void:
	match action_mode:
		EAction.sell:
			ActionManager.action_sell()
		EAction.activate:
			ActionManager.action_activate()
		EAction.research:
			ActionManager.action_research()
		EAction.end_turn:
			GameManager.end_turn()

func _on_discard_button_pressed() -> void:
	ActionManager.action_discard()
