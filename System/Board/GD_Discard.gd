extends Control

@onready var discard_button = $Control/Button
@onready var discard_card = $DiscardCard

var card_number : int  = 0 :
	set(value):
		card_number = value
		discard_button.text = "Discard Pile ("+str(value)+")"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CardManager.discarded = $DiscardCard


func get_all_card() -> Array[Node]:
	return discard_card.get_children()

func _on_discard_card_child_order_changed() -> void:
	card_number = discard_card.get_child_count()
