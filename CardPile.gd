extends Resource
class_name CardPile

@export var cards: Array[CardData] = []

func add_card(card: CardData) -> void:
	if card:
		cards.append(card)

func remove_card(card: CardData) -> bool:
	var index = cards.find(card)
	if index != -1:
		cards.remove_at(index)
		return true
	return false

func shuffle() -> void:
	cards.shuffle()

func transfer_card(card: CardData, target_pile: CardPile) -> bool:
	if remove_card(card):
		target_pile.add_card(card)
		return true
	return false

func draw_from(source_pile: CardPile, amount: int = 1) -> Array[CardData]:
	var drawn_cards: Array[CardData] = []
	for i in range(amount):
		if source_pile.cards.is_empty():
			break
		var card = source_pile.cards.pop_back()
		add_card(card)
		drawn_cards.append(card)
	return drawn_cards

func size() -> int:
	return cards.size()

func is_empty() -> bool:
	return cards.is_empty()
