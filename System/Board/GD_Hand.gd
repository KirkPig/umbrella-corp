extends Control
class_name HandController

signal _card_discarded

signal hand_selection_change
signal discard_transition_done

@export var card_gap: float = 120
@export var hand_width: float = 1200

func _ready() -> void:
	CardManager.hand = self

func _process(delta: float) -> void:
	pass
	
func add_exists(node: Card):
	node.reparent(self)
	if !node.selection_change.is_connected(_selection_change_handler):
		node.selection_change.connect(_selection_change_handler)
	update_position()
	
func get_all_card() -> Array[Node]:
	return self.get_children()

func reset_selection():
	var cards = self.get_children()
	for card: Card in cards:
		card.is_selected = false

func update_position():
	var cards = self.get_children()
	var i = 0
	cards.sort_custom(_compare_card)
	for card: Card in cards:
		card.set_card_hand_position(i, cards.size(), 0, hand_width, card_gap, true)
		i+=1

func get_selected_card() -> Array[Card]:
	var selected_card : Array[Card]
	for card in self.get_children():
		if card is Card and card.is_selected:
			selected_card.append(card)
	return selected_card

func start_discard_transition():
	_card_exit(Vector2(-500, global_position.y))
	await _card_discarded
	discard_transition_done.emit()

func _card_exit(_exit_global_pos: Vector2):
	var _parent = self.get_parent()
	var _exit_pos = _exit_global_pos - _parent.global_position
	var selected_card = CardManager.get_selected_card()
	var n = selected_card.size()
	
	for _c in selected_card:
		var _old_pos = _c.global_position
		_c.reparent(_parent)
		_c.global_position = _old_pos
	
	update_position()
	
	for i in n:
		var _old_pos_list: Array[Vector2]
		for _node in selected_card:
			_old_pos_list.append(_node.position)
		selected_card[i].change_card_position(_exit_pos, 0.2 / GameManager.game_speed)
		for j in range(i + 1, n):
			selected_card[j].change_card_position(_old_pos_list[j - 1], 0.2 / GameManager.game_speed)
		
		await get_tree().create_timer(0.13 / GameManager.game_speed).timeout
	
	await get_tree().create_timer(0.1 / GameManager.game_speed).timeout
	_card_discarded.emit()

func _selection_change_handler():
	hand_selection_change.emit()

func _compare_card(a: Card, b: Card) -> bool:
	return a.card_id < b.card_id
