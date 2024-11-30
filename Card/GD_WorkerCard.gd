extends Card
class_name WorkerCard

var card_data: WorkerCardData:
	set(value):
		if card_data:
			card_data.changed.disconnect(refresh_data)
		value.changed.connect(refresh_data)
		card_data = value
		set_data(value)

var base_work_rate : int
var special_work_rate : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func set_data(data: WorkerCardData):
	set_base_data(data)
	base_work_rate = data.base_work_rate
	special_work_rate = data.special_work_rate
	s_tooltips.set_labor(data.base_work_rate)
	if data and len(data.keyword_list) > 0:
		s_tooltips.set_keywords(data.keyword_list)
	if data and data.Effect != "":
		s_tooltips.set_effect(data.Effect)

func refresh_data():
	set_base_data(card_data)
	base_work_rate = card_data.base_work_rate
	special_work_rate = card_data.special_work_rate
	s_tooltips.set_labor(card_data.base_work_rate)
	if card_data and len(card_data.keyword_list) > 0:
		s_tooltips.set_keywords(card_data.keyword_list)
	if card_data and card_data.Effect != "":
		s_tooltips.set_effect(card_data.Effect)

func yield_labor_value(business: UIBusiness):
	var _id = business.business_card_data.card_id
	if special_work_rate.has(_id):
		return special_work_rate[_id]
	return base_work_rate
