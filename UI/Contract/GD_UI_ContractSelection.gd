extends Control
class_name UIContractSelection

signal select_contract_ready

@onready var template_contract = preload("res://UI/Contract/Component/Scene/S_UI_Contract.tscn")
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var contract_list = $List

@onready var _panel = $Panel
@onready var _placeholder = $Placeholder
var _placeholder_visibility: float = 1:
	set(value):
		_placeholder.modulate.a = value
		_placeholder_visibility = value
var _contract_list_visibility: float = 1:
	set(value):
		contract_list.modulate.a = value
		_contract_list_visibility = value

func _ready() -> void:
	clear_contract()
	GameManager.contract_selection = self

func start_select_contract():
	_placeholder_visibility = 0
	_contract_list_visibility = 0
	var tween: Tween
	tween = create_tween()
	tween.tween_property(self, "_placeholder_visibility", 1, 0.5)
	await tween.finished
	tween = create_tween()
	tween.tween_property(self, "_contract_list_visibility", 1, 0.5)
	await tween.finished
	select_contract_ready.emit()

func add_contract(_data: ContractData) -> void:
	var contract = _add_contract(_data)
	contract.checking_contract.connect(_focus_contract)
	contract.choose_contract.connect(_choose_contract)

func clear_contract() -> void:
	for item in contract_list.get_children():
		contract_list.remove_child(item)
		if is_instance_valid(item):
			item.queue_free()

func fill_tutorial_contract() -> void:
	var _arr_data = ContractManager.load_tutorial_contract()
	for _data in _arr_data:
		add_contract(_data)
	pass

func fill_random_contract(_n: int) -> void:
	var _mul = (GameManager.current_contract + 1) ** min(2, GameManager.current_contract)
	var _arr_data = ContractManager.get_random_contract_data(_n, _mul)
	for _data in _arr_data:
		add_contract(_data)
	pass

# Private function
func _choose_contract(_contract: UIContract):
	audio_stream_player.play()
	GameManager.select_contract(_contract)


func _focus_contract(_contract: UIContract):
	for _c: UIContract in contract_list.get_children():
		if _c != _contract:
			_c.is_selected = false

func _add_contract(_data: ContractData) -> UIContract:
	var contract: UIContract = template_contract.instantiate()
	contract_list.add_child(contract)
	contract.data = _data
	contract.is_disable_selection = false
	return contract
