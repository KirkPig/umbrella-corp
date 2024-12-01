extends Control
class_name UITutorial

signal continue_tutorial

signal start_up_finished
signal contract_finished
signal phone_give_finished
signal play_phone_flow_finished

signal _worker_speech_finish

@onready var _worker = $Worker
@onready var _btn_continue = $Continue
@onready var _text_speech: UITutorialTextSpeech = $TextSpeech
@onready var _continue_label = $ContinueText
@onready var _bubble = $Bubble

var _start_up_text: Array[String] = [
	"Hello, boss. I am your secretary, sir.",
	"Congratulation on your CEO position, sir.",
	"Our company need guidance from you. As right now, our stakeholder not happy with our performance",
	"But, Do not need to worry, Boss! I know that, We will have a bright future under your vision.",
	"As your first day, I might need to guide you. As some of our operation might be a little hard to understand.",
	"Our business is mostly production based company, so you will deal with production and workforce that you need to make a decision.",
]

var _contract_text: Array[String] = [
	"First, we have to select our stakeholder contract.",
	"The contract is the target that we promise our stakeholder in each deadline day",
	"If we can reach the target before deadline, we will get the reward from our happy stakeholder.",
	"On the other hand, if we cannot make it, our stakeholder will not happy and you will lose your job!",
	"So, please be careful before promise to our guys. They are very concerned of our operation here.",
	"Right now, I make some call to our stakeholder before you came. So, they come up with a learning period contract for you.",
	"Select, and confirm your choosing so we can continue."
]

var _phone_give_text: Array[String] = [
	"Now, our administration team have a gift for you.",
	"It's your new phone!"
]

var _phone_flow_text: Array[String] = [
	"With this phone, you can make all decision as easy as you point and click!",
	"You can do a lot of thing with this phone! Work related, Of course.",
	"Our team very proud of this innovation. But there are some issue.",
	"This phone is a prototype. So, most of functionality is quite new.",
	"But, you might not know. I am the head of researcher before take the secretary position.",
	"So, I can walk you through some of it.",
]

var _asset_flow_text: Array[String] = [
	"First is the Assets",
	"This is the list of our assets that we have in the moment",
	"All of it are represent as a card",
	"There are three type of asset; Worker, resource, and instant campaign."
]

var _worker_flow_text: Array[String] = [
	"As a start of our journey, we only have 10 workers with us right now",
	"But do not worry. Our assets will be expands."
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.tutorial_screen = self

func play_start_up():
	_play_worker_speech(_start_up_text)
	await _worker_speech_finish
	start_up_finished.emit()

func play_contract():
	_play_worker_speech(_contract_text)
	await _worker_speech_finish
	contract_finished.emit()

func play_phone_give():
	_play_worker_speech(_phone_give_text)
	await _worker_speech_finish
	phone_give_finished.emit()

func play_phone_flow():
	_play_worker_speech(_phone_flow_text)
	await _worker_speech_finish
	$AssetFlow.show()
	_play_worker_speech(_asset_flow_text)
	await _worker_speech_finish
	$AssetFlow.hide()
	$CurrentAsset.show()
	_play_worker_speech(_worker_flow_text)
	await _worker_speech_finish
	$CurrentAsset.hide()
	play_phone_flow_finished.emit()

func _play_worker_speech(_arr: Array[String]):
	show()
	_bubble.show()
	_text_speech.show()
	_worker.show()
	for _s in _arr:
		_text_speech.full_text = _s
		_continue_label.hide()
		_text_speech.start_animation(0.5)
		await _text_speech.text_typing_finished
		_continue_label.show()
		await continue_tutorial
	_text_speech.hide()
	_bubble.hide()
	_continue_label.hide()
	_worker.hide()
	hide()
	_worker_speech_finish.emit()

func _on_continue_pressed() -> void:
	continue_tutorial.emit()
