extends CanvasLayer

var time:int = 0
@onready var time_label = $"Control/TextureRect/VSplitContainer/Data/Time Label"
@onready var energy_label = $Control/TextureRect/VSplitContainer/Data/Control/Energy
@onready var energy_progress = $Control/TextureRect/VSplitContainer/Data/Control/TextureProgressBar

@onready var action_screen = $Control/TextureRect
@onready var out_of_energy_screen = $"Control/Our of energy"

@onready var gold_panel = $Control/TextureRect/VSplitContainer/money/PanelContainer
@onready var gold_label = $Control/TextureRect/VSplitContainer/money/PanelContainer/HSplitContainer/MarginContainer/Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_energy_change.connect(_on_energy_change)
	GameManager.max_energy_change.connect(_on_max_energy_change)
	GameManager.gold_change.connect(_on_gold_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	time += 1
	var hour :int= int(time/3600)
	var minute :String=  str(int(time/60)) if int(time/60) > 9 else "0" + str(int(time/60))
	var sec :String= str(int(time%60)) if int(time%60) > 9 else "0" + str(int(time%60))
	time_label.text = str(hour) + ":" + minute + ":" + sec \
					if hour > 0 else minute + ":" + sec

func _on_max_energy_change(max_energy:int) -> void:
	pass

func _on_energy_change(energy:int) -> void:
	energy_label.text = str(energy*25) + "%"
	energy_progress.value = energy
	action_screen.visible = energy > 0
	out_of_energy_screen.visible = energy ==0 

func _on_gold_change(gold:int) -> void:
	gold_label.text = "$ "+str(gold)
