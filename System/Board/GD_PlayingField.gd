extends Control
class_name PlayingFieldController

signal playing_cards_done

signal _card_entered
signal _bouncing_done
signal _card_exited

@export var card_gap: float = 190
@export var field_width: float = 1200

var card_in_play: Array[Card]

func playing_cards(_nodes: Array[Card], _exit_global_pos: Vector2, _destroy: bool):
	if _nodes.size() <= 0:
		return
	_card_enter(_nodes)
	await _card_entered
	_bouncing_each_card()
	await _bouncing_done
	_card_exit(_exit_global_pos)
	await _card_exited
	if _destroy:
		_clear_cards_in_play()
	card_in_play = []
	emit_signal("playing_cards_done")
	
func _ready() -> void:
	ActionManager.playing_field = self

func _card_exit(_exit_global_pos: Vector2):
	var _exit_pos = _exit_global_pos - global_position
	var n = card_in_play.size()
	
	for i in n:
		var _old_pos_list: Array[Vector2]
		for _node in card_in_play:
			_old_pos_list.append(_node.position)
		card_in_play[i].change_card_position(_exit_pos, 0.2 / GameManager.game_speed)
		for j in range(i + 1, n):
			card_in_play[j].change_card_position(_old_pos_list[j - 1], 0.2 / GameManager.game_speed)
		
		await get_tree().create_timer(0.13 / GameManager.game_speed).timeout
	
	await get_tree().create_timer(0.5 / GameManager.game_speed).timeout
	emit_signal("_card_exited")

func _clear_cards_in_play():
	for _card in card_in_play:
		remove_child(_card)
		if is_instance_valid(_card):
			_card.queue_free()

func _bouncing_each_card():
	for _card in card_in_play:
		_card.bouncing_card()
		await _card.card_scaling_up
		await get_tree().create_timer(0.2 / GameManager.game_speed).timeout
	await get_tree().create_timer(0.5 / GameManager.game_speed).timeout
	emit_signal("_bouncing_done")

func _card_enter(_nodes: Array[Card]):
	_nodes.sort_custom(_sort_by_global_x)
	var n = _nodes.size()
	
	# reparent without changing position
	for _node: Card in _nodes:
		var _old_pos = _node.global_position
		_node.reparent(self)
		_node.is_selected = false
		_node.global_position = _old_pos + Vector2(0, -_node.toggle_up_pixel)
	
	# animation
	for i in n:
		var _old_pos_list: Array[Vector2]
		for _node in _nodes:
			_old_pos_list.append(_node.position)
		_nodes[i].change_card_position(Vector2(field_width / 3 * 2, 0), 0.2 / GameManager.game_speed)
		for j in range(i + 1, n):
			_nodes[j].change_card_position(_old_pos_list[j - 1], 0.2 / GameManager.game_speed)
		
		await get_tree().create_timer(0.13 / GameManager.game_speed).timeout
		
		card_in_play.append(_nodes[i])
		_update_position()
	
	await _nodes[0].tween_moving.finished
	emit_signal("_card_entered")

func _update_position():
	var i = 0
	for card: Card in card_in_play:
		card.set_card_hand_position(i, card_in_play.size(), 0, field_width, card_gap, false)
		i+=1

func _sort_by_global_x(a: Card, b: Card) -> bool:
	return a.global_position.x < b.global_position.x
