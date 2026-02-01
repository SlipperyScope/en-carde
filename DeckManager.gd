extends Resource
class_name DeckManager

const CARD_DICT_PATH = "res://cardDict.json"

static func load_deck() -> Array[CardData]:
	var deck: Array[CardData] = []
	
	if not FileAccess.file_exists(CARD_DICT_PATH):
		push_error("Card config file not found: " + CARD_DICT_PATH)
		return deck
		
	var file = FileAccess.open(CARD_DICT_PATH, FileAccess.READ)
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var error = json.parse(json_string)
	if error != OK:
		push_error("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
		return deck
		
	var data = json.data
	if not data.has("cards"):
		push_error("JSON does not contain 'cards' key")
		return deck
		
	for card_info in data["cards"]:
		var count = card_info.get("count", 1)
		for i in range(count):
			var card = create_card_from_info(card_info)
			deck.append(card)
			
	return deck

static func create_card_from_info(info: Dictionary) -> CardData:
	var card = CardData.new()
	card.card_name = info.get("name", "Unknown Card")
	
	var slots_info = info.get("slots", {})
	if slots_info.has("top"):
		set_slot_from_dict(card, CardData.Position.TOP, slots_info["top"])
	if slots_info.has("middle"):
		set_slot_from_dict(card, CardData.Position.MIDDLE, slots_info["middle"])
	if slots_info.has("bottom"):
		set_slot_from_dict(card, CardData.Position.BOTTOM, slots_info["bottom"])
		
	return card

static func set_slot_from_dict(card: CardData, pos: CardData.Position, slot_dict: Dictionary) -> void:
	var action_str = slot_dict.get("action", "ATTACK")
	var value = slot_dict.get("value", 0)
	
	
	var action_enum = CardSlot.ACTIONS.ATTACK
	if CardSlot.ACTIONS.has(action_str):
		action_enum = CardSlot.ACTIONS[action_str]
	else:
		push_warning("Unknown action: " + action_str + " using ATTACK as fallback")
		
	card.set_slot(pos, action_enum, value)
