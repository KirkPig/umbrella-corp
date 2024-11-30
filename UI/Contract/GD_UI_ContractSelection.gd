extends Control
class_name UIContractSelection

@onready var template_contract = preload("res://UI/Contract/Component/Scene/S_UI_Contract.tscn")

@onready var contract_list = $List

func _ready() -> void:
	clear_contract()
	GameManager.contract_selection = self

func add_contract(_data: ContractData) -> void:
	var contract = _add_contract(_data)
	contract.checking_contract.connect(_focus_contract)
	contract.choose_contract.connect(_choose_contract)

func clear_contract() -> void:
	for item in contract_list.get_children():
		contract_list.remove_child(item)
		if is_instance_valid(item):
			item.queue_free()

# Private function
func _choose_contract(_contract: UIContract):
	GameManager.select_contract(_contract)


func _focus_contract(_contract: UIContract):
	for _c in contract_list.get_children():
		if _c is UIContract and _c != _contract:
			_c.is_selected = false

func _add_contract(_data: ContractData) -> UIContract:
	var contract: UIContract = template_contract.instantiate()
	contract_list.add_child(contract)
	contract.data = _data
	return contract
