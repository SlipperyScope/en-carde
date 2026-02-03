extends Node2D

@export var DeckResource: GoldDeck

var _Deck: Array[GoldCardInst] = []
var _DrawPile: Array[GoldCardInst] = []


func _ready():
	_Deck = DeckResource.PrintDeck()
	
	for card in _Deck:
		_DrawPile.append(card)

	var hand: Array[GoldCardInst] = Draw(8)

	%GoldUI.Deal(hand)

	pass

func Draw(count: int) -> Array[GoldCardInst]:
	var hand: Array[GoldCardInst] = []

	if (count > _DrawPile.size()):
		count = _DrawPile.size()

	for i in range(count):
		hand.append(_DrawPile.pop_back())

	return hand
