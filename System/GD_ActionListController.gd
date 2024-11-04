extends VBoxContainer

signal btn_sell_pressed
signal btn_discard_pressed
signal btn_end_pressed

@onready var btn_sell = $SellButton
@onready var btn_discard = $DiscardButton
@onready var btn_end = $EndTurnButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#btn_working.hide()
	btn_sell.hide()
	btn_discard.hide()
	btn_end.show()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_list(selected_card: Array[Card]):
	
	if selected_card.size() <= 0:
		#btn_working.hide()
		btn_sell.hide()
		btn_discard.hide()
		return
	
	var show_btn_working = true
	var show_btn_sell = true
	for card in selected_card:
		if card is WorkerCard:
			show_btn_sell = false
		if card is ResourceCard:
			show_btn_working = false
	
	#btn_working.visible = show_btn_working
	btn_sell.visible = show_btn_sell
	btn_discard.show()
	pass

func _on_sell_button_pressed() -> void:
	emit_signal("btn_sell_pressed")
	pass # Replace with function body.


func _on_discard_button_pressed() -> void:
	emit_signal("btn_discard_pressed")
	pass # Replace with function body.


func _on_end_turn_button_pressed() -> void:
	emit_signal("btn_end_pressed")
	pass # Replace with function body.
