extends Control
class_name ContractSelection

const contract = preload("res://System/Contract/S_Contract.tscn")
@onready var contract_list: HBoxContainer = $ContractList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(3):
		var contract = create_contract()# Replace with function body.
		contract_list.add_child(contract)

func create_contract() -> Contract:
	var random_contract : Contract = contract.instantiate()
	var resource_file = DirAccess.get_files_at("res://Resource/Contract/")
	var random_resource = resource_file[randi() % resource_file.size()]
	#print(random_resource.contract_res)
	random_contract.contract_res = load("res://Resource/Contract/" + random_resource)
	return random_contract

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
