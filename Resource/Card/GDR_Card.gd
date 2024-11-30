extends Resource
class_name CardData

@export var card_id: int
@export var card_name: String
@export var card_texture: Texture2D
@export var shop_price: int
@export var card_icon: Texture2D

@export_group("Tool Tips")
@export_multiline var Effect:String
@export var resource_id_list:Array[int]
@export var keyword_list:Array[ToolTipsKeyword.EKeyword]
