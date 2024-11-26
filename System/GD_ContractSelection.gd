extends Control
class_name ContractSelection

const contract = preload("res://Contract/S_Contract.tscn")
@onready var contract_list: HBoxContainer = $ContractList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.contract_selection = self

func start_select_contract() -> void:
	visible = true
	for i in range(3):
		var contract = create_contract()# Replace with function body.
		contract_list.add_child(contract)
		
func clear_contract() -> void:
	for contract in contract_list.get_children():
		contract_list.remove_child(contract)
		contract.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
