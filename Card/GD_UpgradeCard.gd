extends Card
class_name UpgradeCard

var card_data: UpgradeCardData:
	set(value):
		if card_data:
			card_data.changed.disconnect(refresh_data)
		value.changed.connect(refresh_data)
		card_data = value
		set_data(value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func set_data(data: UpgradeCardData):
	set_base_data(data)
	if len(data.keyword_list) > 0:
		s_tooltips.set_keywords(data.keyword_list)
	if data.Effect != "":
		s_tooltips.set_effect(data.Effect)

func refresh_data():
	set_base_data(card_data)
	if len(card_data.keyword_list) > 0:
		s_tooltips.set_keywords(card_data.keyword_list)
	if card_data.Effect != "":
		s_tooltips.set_effect(card_data.Effect)
