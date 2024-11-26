extends Node

func get_random_contract_data() -> ContractData:
	var resource_file = DirAccess.get_files_at("res://Resource/Contract/Data/")
	var random_resource = resource_file[GameManager.rng.randi() % resource_file.size()]
	return load("res://Resource/Contract/Data/" + random_resource)
