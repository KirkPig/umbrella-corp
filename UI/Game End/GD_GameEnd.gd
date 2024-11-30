extends CanvasLayer

@onready var title_label: Label = $Panel/PanelContainer/MarginContainer/VBoxContainer/TitleLabel
@onready var total_score_label: Label = $Panel/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/Control/HBoxContainer/TotalScoreLabel
@onready var most_score_label: Label = $Panel/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/Control2/HBoxContainer/MostScoreLabel
@onready var most_sell_container: HBoxContainer = $Panel/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/Control3/MostSellContainer
@onready var most_sell_icon: TextureRect = $Panel/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/Control3/MostSellContainer/Container/MostSellIcon
@onready var most_sell_label: Label = $Panel/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/Control3/MostSellContainer/MostSellLabel
@onready var resource_founded_label: Label = $Panel/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/Control4/ResourceFoundedLabel
@onready var resource_founded_container: HBoxContainer = $Panel/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/Control4/ResourceFoundedContainer

var start_resource_list : Array[int] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.game_end.connect(game_end)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_end(win:bool) -> void:
	self.visible = true
	get_tree().paused = true
	title_label.text = "You win...? Congrats!" if win else "Bankrupt!....Not really"
	total_score_label.text = str(GameManager.total_score)
	most_score_label.text = str(GameManager.most_score_contract)
	add_most_sell_resource()
	add_founded_resource()

func add_most_sell_resource():
	var most_sell_id:int =-1
	var most_sell_amount:int =-1
	for card_id in SellManager.sell_history:
		if SellManager.sell_history[card_id] > most_sell_amount:
			most_sell_id= card_id
			most_sell_amount = SellManager.sell_history[card_id]
	
	if most_sell_id > -1:
		most_sell_container.visible = true
		most_sell_icon.texture  = load("res://Assets/Icon/A_ResourceIcon_"+str(most_sell_id)+".png")
		var card_data = CardManager.card_dict[most_sell_id]
		most_sell_label.text = card_data.card_name


func add_founded_resource():
	var founded_amount:int = 0
	for card_id in CardManager.card_pool:
		if card_id >=2000 and card_id < 3000 and card_id not in start_resource_list:
			var tr = TextureRect.new()
			tr.texture = load("res://Assets/Icon/A_ResourceIcon_"+str(card_id)+".png")
			resource_founded_container.add_child(tr)
			founded_amount+= 1
	resource_founded_label.text = "Resource founded ("+str(founded_amount)+"/99)"
	
func _on_new_game_pressed() -> void:
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://System/Main Menu/S_Main_Menu.tscn")

func _on_desktop_pressed() -> void:
	get_tree().quit()
