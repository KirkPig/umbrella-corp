extends Node

func get_random_contract_data(_multiply: int) -> ContractData:
	var resource_file = DirAccess.get_files_at("res://Resource/Contract/Data/")
	var random_resource = resource_file[GameManager.rng.randi() % resource_file.size()]
	var _data: ContractData = load("res://Resource/Contract/Data/" + random_resource)
	_data.score_goal = _data.score_goal * _multiply
	return _data
