extends VBoxContainer
class_name ActionListController

@onready var btn_sell = $SSell
@onready var btn_research = $SResearch
@onready var btn_discard = $SDiscard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ActionManager.action_list = self
	print(btn_research.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_list(selected_card: Array[Card] ):
	btn_sell.visible = GameManager.can_sell(selected_card)
	btn_research.visible = GameManager.can_research(selected_card)
	btn_discard.visible = GameManager.can_discard(selected_card)
	$Control.visible = GameManager.can_sell(selected_card) or GameManager.can_research(selected_card) or GameManager.can_discard(selected_card)
	
func reset_list():
	update_list([])

	
func _on_sell_button_pressed() -> void:
	ActionManager.action_sell()

func _on_research_button_pressed() -> void:
	ActionManager.action_research()

func _on_discard_button_pressed() -> void:
	ActionManager.action_discard()
