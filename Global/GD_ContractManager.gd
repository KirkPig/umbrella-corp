extends Node

var completed_contract: Array[int]

func get_random_contract_data(_n: int, _multiply: int) -> Array[ContractData]:
	var _arr: Array[ContractData] = []
	var _load_contract: Array[ContractData] = _load_all_contract(_multiply)
	_load_contract.shuffle()
	for _i in _n:
		var _data = _load_contract.pop_front()
		_arr.append(_data)
	return _arr

func _load_all_contract(_multiply: int) -> Array[ContractData]:
	var _arr: Array[ContractData] = []
	var resource_file = DirAccess.get_files_at("res://Resource/Contract/Data/")
	for _res in resource_file:
		var _data: ContractData = load("res://Resource/Contract/Data/" + _res)
		_data.score_goal = _data.score_goal * _multiply
		_arr.append(_data)
	return _arr
