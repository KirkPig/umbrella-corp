extends VBoxContainer
class_name ActionListController

@onready var btn_sell = $SSell
@onready var btn_research = $SResearch
@onready var btn_discard = $SDiscard
@onready var research_audio_stream_player: AudioStreamPlayer = $ResearchAudioStreamPlayer
@onready var sell_audio_stream_player: AudioStreamPlayer = $SellAudioStreamPlayer
@onready var discard_audio_stream_player: AudioStreamPlayer = $DiscardAudioStreamPlayer
@onready var draw_audio_stream_player: AudioStreamPlayer = $DrawAudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ActionManager.action_list = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_list(selected_card: Array[Card]):
	btn_sell.visible = GameManager.can_sell(selected_card)
	btn_research.visible = GameManager.can_research(selected_card)
	btn_discard.visible = GameManager.can_discard(selected_card)
	GameManager.can_activate(selected_card)
	$Control.visible = GameManager.can_sell(selected_card) or GameManager.can_research(selected_card) or GameManager.can_discard(selected_card)
	
func reset_list():
	var selected_cards = CardManager.get_selected_card()
	update_list(selected_cards)
	
func _on_sell_button_pressed() -> void:
	ActionManager.action_sell()
	sell_audio_stream_player.play()

func _on_research_button_pressed() -> void:
	ActionManager.action_research()
	research_audio_stream_player.play()

func _on_discard_button_pressed() -> void:
	ActionManager.action_discard()
	discard_audio_stream_player.play()
