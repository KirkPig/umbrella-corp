extends CanvasLayer

var time:int = 0
@onready var time_label = $"Control/TextureRect/VSplitContainer/Data/Time Label"
@onready var energy_label = $Control/TextureRect/VSplitContainer/Data/Control/Energy
@onready var energy_progressl = $Control/TextureRect/VSplitContainer/Data/Control/TextureProgressBar
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_energy_change.connect(_on_energy_change)
	GameManager.max_energy_change.connect(_on_max_energy_change)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	time += 1
	var hour :int= int(time/3600)
	var minute :String=  str(int(time/60)) if int(time/60) > 10 else "0" + str(int(time/60))
	var sec :String= str(int(time%60)) if int(time%60) > 10 else "0" + str(int(time%60))
	time_label.text = str(hour) + ":" + minute + ":" + sec \
					if hour > 0 else minute + ":" + sec

func _on_max_energy_change(max_energy:int) -> void:
	energy_progressl.max_value = max_energy

func _on_energy_change(energy:int) -> void:
	energy_label.text = str(energy*25) + "%"
	energy_progressl.value = energy
