extends Resource

## A deck of GoldCards; the number of each type of card
class_name GoldDeck

@export var CardBack: Texture2D ## Back of the card
@export var CardFront: Texture2D ## Background of the card front
@export var Stances: Dictionary[EnumDefinitions.CardStance, Texture2D] = { ## Texture overlay for each stance
	EnumDefinitions.CardStance.Null: null,
	EnumDefinitions.CardStance.Attack: null,
	EnumDefinitions.CardStance.Defend: null,
	EnumDefinitions.CardStance.Vulnerable: null,
	EnumDefinitions.CardStance.Passthrough: null,
}

@export var Cards: Array[GoldCardCount] = [] ## Number of each card to print

func PrintDeck() -> Array[GoldCardInst]:
	var deck: Array[GoldCardInst] = []

	var id: int = 100

	for counts in Cards:
		for i in range(counts.Count):
			deck.append(counts.Card.PrintCard(str(id), self ))
			id += 100

	deck.shuffle()
	return deck
