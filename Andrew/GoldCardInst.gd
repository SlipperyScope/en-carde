extends Object

# An instance of a GoldCard
class_name GoldCardInst

## Unique ID for this card
var ID: String = ""

## Card info[br]Note: Changing this will change it for [b]all[/b] cards of this type
var _CardInfo: GoldCard

## Info about the deck this card is part of
var _DeckInfo: GoldDeck

## Texture for front of card
var FrontTexture: Texture2D:
	get: return _DeckInfo.CardFront

## Texture for the back of the card
var BackTexture: Texture2D:
	get: return _DeckInfo.CardBack

## Texture for the graphic overlay
var GraphicTexture: Texture2D:
	get: return _CardInfo.Graphic

## Texture for the top stance
var TopStanceTexture: Texture2D:
	get: return _DeckInfo.Stances[_CardInfo.TopStance]

## Texture for the middle stance
var MiddleStanceTexture: Texture2D:
	get: return _DeckInfo.Stances[_CardInfo.MiddleStance]

## Texture for the bottom stance
var BottomStanceTexture: Texture2D:
	get: return _DeckInfo.Stances[_CardInfo.BottomStance]

var TopStance: EnumDefinitions.CardStance:
	get: return _CardInfo.TopStance

var MiddleStance: EnumDefinitions.CardStance:
	get: return _CardInfo.MiddleStance

var BottomStance: EnumDefinitions.CardStance:
	get: return _CardInfo.BottomStance

func Build(id: String, card: GoldCard, deck: GoldDeck) -> void:
	ID = id
	_CardInfo = card
	_DeckInfo = deck