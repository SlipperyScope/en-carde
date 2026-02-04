extends Node2D

@export var Deck: P_DeckInfo
@export var CardCompositor: P_CardCompositor

func _ready():
	var card1 = Deck.Cards.keys()[0]
	var card2 = Deck.Cards.keys()[1]

	print("card 1: %s, card 2: %s" % [card1, card2])

	var params = P_CardCompositor.CompositeParams.Make(Deck, card1, "123")
	var params2 = P_CardCompositor.CompositeParams.Make(Deck, card2, "456")
	var tex = await CardCompositor.Composite(self , params)
	print(tex)
	%card_1.texture = tex

	tex = await CardCompositor.Composite(self , params2)
	print(tex)
	%card_2.texture = tex
