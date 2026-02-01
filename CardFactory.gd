extends Resource
class_name CardFactory

const CARD_DICT_PATH = "res://cardDict.json"

static func load_deck_data() -> Array[CardData]:
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
			var card = create_card_from_info(card_info, "%s:%s" % [card_info.get("id"), i])
			deck.append(card)

	return deck

static func create_card_from_info(info: Dictionary, id: String) -> CardData:
	return create_card(
		id,
		{"action": info.get("top", "ATTACK"), "strength": info.get("top_strength", 1)},
		{"action": info.get("middle", "ATTACK"), "strength": info.get("middle_strength", 1)},
		{"action": info.get("bottom", "ATTACK"), "strength": info.get("bottom_strength", 1)}
	)

static func create_card(id: String, top: Dictionary, middle: Dictionary, bottom: Dictionary) -> CardData:
	var card = CardData.new()
	card.id = id

	set_slot_from_action_str(card, CardData.Position.TOP, top.get("action", "ATTACK"), top.get("strength", 1))
	set_slot_from_action_str(card, CardData.Position.MIDDLE, middle.get("action", "ATTACK"), middle.get("strength", 1))
	set_slot_from_action_str(card, CardData.Position.BOTTOM, bottom.get("action", "ATTACK"), bottom.get("strength", 1))

	return card

static func set_slot_from_action_str(card: CardData, pos: CardData.Position, action_str: String, strength: int = 1) -> void:
	var action_enum = CardSlot.ACTIONS.ATTACK
	if CardSlot.ACTIONS.has(action_str):
		action_enum = CardSlot.ACTIONS[action_str]
	else:
		push_warning("Unknown action: " + action_str + " using ATTACK as fallback")

	card.set_slot(pos, action_enum, strength)

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
