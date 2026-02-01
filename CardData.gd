extends Resource
class_name CardData

enum Position { TOP, MIDDLE, BOTTOM }

@export var card_name: String:
	get:
		return _get_action_initial(top.action) + " | " + _get_action_initial(middle.action) + " | " + _get_action_initial(bottom.action)

func _get_action_initial(action: CardSlot.ACTIONS) -> String:
	match action:
		CardSlot.ACTIONS.ATTACK: return "A"
		CardSlot.ACTIONS.DEFEND: return "D"
		CardSlot.ACTIONS.OPEN: return "O"
		CardSlot.ACTIONS.MASK: return "_"
	return "?"
@export var card_image: Texture

@export var id: String = ""

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
