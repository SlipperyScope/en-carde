extends Node2D

const DISCARD_TEXT = "Select % more cards to discard"

enum ClientState {
	Init,
	Deal,
	Discard,
	Play,
	Wait,
	Score
}

var _CurrentState: ClientState = ClientState.Init

@export var DeckResource: GoldDeck
@export var GameRule: GoldGameRule

var _Deck: Array[GoldCardInst] = []
var _DrawPile: Array[GoldCardInst] = []
var _DiscardPile: Array[GoldCardInst] = []

func _ready():
	_Deck = DeckResource.PrintDeck()
	for card in _Deck:
		_DrawPile.append(card)
	_StartDealPhase()

func _StartDealPhase():
	print("Starting deal phase...")
	_CurrentState = ClientState.Deal
	%GoldUI.EnableDealButton()
	%GoldUI.DealButtonPressed.connect(_on_deal_button_pressed)

func _on_deal_button_pressed() -> void:
	%GoldUI.DealButtonPressed.disconnect(_on_deal_button_pressed)
	%GoldUI.DisableDealButton()
	var hand: Array[GoldCardInst] = Draw(GameRule.Draw)
	%GoldUI.DealFinished.connect(_StartDiscardPhase)
	%GoldUI.Deal(hand)

func _StartDiscardPhase() -> void:
	print("Starting discard phase...")
	%GoldUI.DealFinished.disconnect(_StartDiscardPhase)
	%GoldUI.MaxSelectableCards = GameRule.Discard
	%GoldUI.EnableDiscardButton()
	_CurrentState = ClientState.Discard
	%GoldUI.DiscardButtonPressed.connect(_on_discard_button_pressed)

func _on_discard_button_pressed() -> void:
	%GoldUI.DiscardButtonPressed.disconnect(_on_discard_button_pressed)
	%GoldUI.DisableDiscardButton()
	pass

func Draw(count: int) -> Array[GoldCardInst]:
	var hand: Array[GoldCardInst] = []

	if (count > _DrawPile.size()):
		push_warning("Tried to draw %s cards but the deck only had %s" % [count, _DrawPile.size()])
		count = _DrawPile.size()

	for i in range(count):
		hand.append(_DrawPile.pop_back())

	return hand

func _on_discard_finished() -> void:
	%GoldUI.DiscardFinished.disconnect(_on_discard_finished)
	%Discard.visible = false
	_CurrentState = ClientState.Play
