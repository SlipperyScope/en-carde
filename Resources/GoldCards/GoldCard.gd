extends Resource
# Resource info for a Gold™ card
class_name GoldCard

@export var CardName: String
@export_multiline var Description: String
@export var Graphic: Texture2D
@export var Front: Texture2D
@export var Back: Texture2D
@export var TopStance: EnumDefinitions.CardStance
@export var MiddleStance: EnumDefinitions.CardStance
@export var BottomStance: EnumDefinitions.CardStance

var _ID: String

# Card ID, unique to instance
var ID: String:
	get: return _ID

# Sets the instance ID
func SetID(id: String) -> void:
	_ID = id