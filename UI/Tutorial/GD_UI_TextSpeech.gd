extends Label
class_name UITutorialTextSpeech

signal text_typing_finished

var full_text: String:
	set(value):
		visible_ratio = 0
		text = value
		full_text = value

func start_animation(_t: float):
	var tween = create_tween()
	tween.tween_property(self, "visible_ratio", 1, _t)
	await tween.finished
	text_typing_finished.emit()
