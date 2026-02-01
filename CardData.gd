extends Resource
class_name CardData 

enum Position { TOP, MIDDLE, BOTTOM }

@export var card_name: String
@export var card_image: Texture

@export var top: CardSlot = CardSlot.new()
@export var middle: CardSlot = CardSlot.new()
@export var bottom: CardSlot = CardSlot.new()

func get_slot(pos: Position) -> CardSlot:
	match pos:
		Position.TOP:
			return top
		Position.MIDDLE:
			return middle
		Position.BOTTOM:
			return bottom
	return top # fallback; shouldn't happen


func set_slot(pos: Position, action: CardSlot.ACTIONS, value: int) -> void:
	var slot := get_slot(pos)
	slot.action = action
	slot.strength = value