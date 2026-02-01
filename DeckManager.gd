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
	
	set_slot_from_action_str(card, CardData.Position.TOP, info.get("top", "ATTACK"))
	set_slot_from_action_str(card, CardData.Position.MIDDLE, info.get("middle", "ATTACK"))
	set_slot_from_action_str(card, CardData.Position.BOTTOM, info.get("bottom", "ATTACK"))
	
	return card

static func set_slot_from_action_str(card: CardData, pos: CardData.Position, action_str: String) -> void:
	var action_enum = CardSlot.ACTIONS.ATTACK
	if CardSlot.ACTIONS.has(action_str):
		action_enum = CardSlot.ACTIONS[action_str]
	else:
		push_warning("Unknown action: " + action_str + " using ATTACK as fallback")
		
	card.set_slot(pos, action_enum, 1) # Default strength to 1
	
	# Load image based on action
	var image_path = "res://quoteArtUnquote/"
	match action_enum:
		CardSlot.ACTIONS.ATTACK: image_path += "Attack.png"
		CardSlot.ACTIONS.DEFEND: image_path += "Defend.png"
		CardSlot.ACTIONS.OPEN: image_path += "Open.png"
		_: image_path = "" # MASK doesn't seem to have an image or use default
	
	if image_path != "" and FileAccess.file_exists(image_path):
		card.get_slot(pos).card_image = load(image_path)

static func get_card_slot_image(action: CardSlot.ACTIONS) -> Texture:
	var image_path = "res://quoteArtUnquote/"
	match action:
		CardSlot.ACTIONS.ATTACK: image_path += "Attack.png"
		CardSlot.ACTIONS.DEFEND: image_path += "Defend.png"
		CardSlot.ACTIONS.OPEN: image_path += "Open.png"
		_: return null
	
	if FileAccess.file_exists(image_path):
		return load(image_path)
	return null
