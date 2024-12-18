extends Control
class_name PlayingFieldController

signal selected_resource_done(_card: Card)
signal playing_cards_done
signal playing_change_resource_done
signal playing_research_done

signal _card_entered
signal _bouncing_done
signal _card_exited

signal _card_flashed

@export var card_gap: float = 190
@export var field_width: float = 1200

var card_in_play: Array[Card]

func playing_research(_nodes: Array[Card]):
	for _node in _nodes:
		_node.is_disable_hover = true
	_card_enter(_nodes)
	await _card_entered
	_card_flash()
	await _card_flashed
	for _node in _nodes:
		_node.is_disable_hover = false
	card_in_play = []
	playing_research_done.emit()

func _card_flash():
	var tween = create_tween()
	for _node: Card in card_in_play:
		_node.texture_amount = 0
		_node.texture_flash_rect.show()
		_node.change_card_position(Vector2(field_width / 2, 0), 2 / GameManager.game_speed)
		if tween.is_running():
			tween.set_parallel().tween_property(_node, "texture_amount", 1.0, 3 / GameManager.game_speed)
		else:
			tween.tween_property(_node, "texture_amount", 1.0, 3 / GameManager.game_speed)
	await tween.finished
	_card_flashed.emit()

func playing_change_resource(_res: Array[int]):
	_res.sort()
	for _id in _res:
		_create_local_resource_card(_id)
		await get_tree().create_timer(0.13 / GameManager.game_speed).timeout
	return

func finish_playing_change_resource(_exit_global_pos: Vector2):
	_card_exit(_exit_global_pos)
	await _card_exited
	_clear_cards_in_play()
	card_in_play = []
	playing_change_resource_done.emit()
	
func _ready() -> void:
	ActionManager.playing_field = self

func _create_local_resource_card(_id: int):
	var _card = CardManager.create_resource_card()
	_card.is_buy.disconnect(ActionManager.action_buy)
	add_child(_card)
	_card.card_data = CardManager.card_dict[_id]
	_card.in_shop = true
	_card.global_position = Vector2(2000, global_position.y)
	_card.is_buy.connect(_selected_resoruce)
	card_in_play.append(_card)
	_update_position()

func _selected_resoruce(_card: Card):
	selected_resource_done.emit(_card)

func playing_cards(_nodes: Array[Card], _exit_global_pos: Vector2, _destroy: bool):
	for _node in _nodes:
		_node.is_disable_hover = true
	if _nodes.size() <= 0:
		return
	_card_enter(_nodes)
	await _card_entered
	_bouncing_each_card()
	await _bouncing_done
	_card_exit(_exit_global_pos)
	await _card_exited
	for _node in _nodes:
		_node.is_disable_hover = false
	if _destroy:
		_clear_cards_in_play()
	card_in_play = []
	playing_cards_done.emit()

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
		await get_tree().create_timer(0.5 / GameManager.game_speed).timeout
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
	
	CardManager.business_field.update_child_ui()
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
