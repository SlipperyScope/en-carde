extends Node
class_name ServerTwoPointOh

signal game_started(controller:ServerTwoPointOh)
signal deal_card(id:String)
signal hand_ready()
signal test_play_card_answer(canPlay: bool)

@export var lobby: Node

# Server State
# This stuff is only managed by the server instance (i.e., ID 1)
var game_state = {
	"players": [],
	"current_player": 1,
	"deck": [],
}

var carddb = {}

# Client State
# Every instance has a copy of this stuff, but it's only ever updated by the server
var my_hand = []
var my_hand_scene: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var card_factory = preload("res://CardFactory.gd")
	var card_pile = preload("res://CardPile.gd")

	game_state.deck = card_pile.new()
	game_state.deck.cards = card_factory.load_deck_data()
	game_state.deck.shuffle()

	# Construct a master lookup table
	for c in game_state.deck.cards:
		carddb[c.id] = c

	lobby.letsago.connect(create_game)

func create_game(players):
	for pid in players:
		game_state.players.push_back({
			"id": pid,
			"cards": [],
			"score": 0,
		})

	game_state.deck.shuffle()

	for p in game_state.players:
		p.cards = game_state.deck.take_from(2).map(func ids(c): return c.id)
		set_hand.rpc_id(p.id, p.cards)

func deal(count: int):
	var dealt = []
	for i in range(count):
		dealt.push_back(game_state.deck.pop_front())
	return dealt

@rpc("call_local")
func set_hand(cards):
	game_started.emit(self)
	my_hand = cards
	for c in my_hand:
		deal_card.emit(c)
	hand_ready.emit()

@rpc("call_local", "any_peer", "reliable")
func test_play_card(pid: int, card: String):
	var canPlay = true
	if pid != game_state.current_player:
		canPlay = false
	test_play_card_response.rpc_id(pid, canPlay)

@rpc("call_local", "reliable")
func test_play_card_response(canPlay: bool):
	test_play_card_answer.emit(canPlay)

@rpc("call_local", "any_peer", "reliable")
func play_card(pid: int, card: String):
	# Verify that it is pid's turn
	print("Attempting to play... %s" % card)
	if pid != game_state.current_player:
		print("Not your turn, player %s" % pid)
		return
	var curr = game_state.players.find_custom(func f(p): return p.id == pid)
	if curr != -1:
		var currp = game_state.players[curr]
		var cidx = currp.cards.find(card)
		# Verify that pid has this card
		if cidx == -1:
			print("You don't have this card")
		else:
			# Remove card from pid's hand and re-render
			print("Player %s is playing this card" % pid)
			print(carddb[card])
			# Put the card in the game area
			# Mark the new current player
			game_state.current_player = game_state.players[(curr + 1) % len(game_state.players)].id
