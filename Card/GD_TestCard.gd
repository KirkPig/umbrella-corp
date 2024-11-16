extends Control

@export var card: CardData
@export var shop: CardData

func _on_button_pressed() -> void:
	CardManager.add_card_to_deck(card)
	CardManager.draw()
	pass # Replace with function body.


func _on_add_shop_pressed() -> void:
	CardManager.add_card_to_shop(shop)
	pass # Replace with function body.
