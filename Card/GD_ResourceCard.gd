extends Card
class_name ResourceCard

var card_data: ResourceCardData:
	set(value):
		if card_data:
			card_data.changed.disconnect(refresh_data)
		value.changed.connect(refresh_data)
		card_data = value
		set_data(value)

var yield_score = 10
var yield_gold = 1
var business = 0
var demand = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func set_data(data: ResourceCardData):
	set_base_data(data)
	yield_score = data.yield_price
	yield_gold = data.yield_gold
	business = data.business_id - 1000
	demand = data.yield_demand
	s_tooltips.set_resource(data.card_id)
	if len(data.keyword_list) > 0:
		s_tooltips.set_keywords(data.keyword_list)
	if data.Effect != "":
		s_tooltips.set_effect(data.Effect)

func refresh_data():
	set_base_data(card_data)
	yield_score = card_data.yield_price
	yield_gold = card_data.yield_gold
	business = card_data.business_id - 1000
	demand = card_data.yield_demand
	s_tooltips.set_resource(card_data.card_id)

func _on_card_mouse_entered() -> void:
	super()
	if self is ResourceCard:
		s_tooltips.set_resource(card_data.card_id)
