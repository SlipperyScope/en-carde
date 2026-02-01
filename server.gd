extends Node

@export var lobby: Node

# Server State
# This stuff is only managed by the server instance (i.e., ID 1)
var game_state = {
	"players": [],
	"current_player": 1,
	"deck": [],
}

# Client State
# Every instance has a copy of this stuff, but it's only ever updated by the server
var my_hand = []
var my_hand_scene: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	lobby.letsago.connect(create_game)

func create_game(players):
	for pid in players:
		game_state.players.push_back({
			"id": pid,
			"cards": [],
			"score": 0,
		})
	game_state.deck = []
	for c in Cards.CARDS.keys():
		game_state.deck.push_back({
			"id": c,
			"name": Cards.CARDS[c].name,
			"top": Cards.CARDS[c].top,
			"mid": Cards.CARDS[c].mid,
			"bot": Cards.CARDS[c].bot,
		})

	for p in game_state.players:
		p.cards = deal(2)
		set_hand.rpc_id(p.id, p.cards)

func deal(count: int):
	var dealt = []
	for i in range(count):
		dealt.push_back(game_state.deck.pop_front())
	return dealt

@rpc("call_local")
func set_hand(cards):
	var Player = preload("res://michael_hand.tscn")
	if my_hand_scene == null:
		my_hand_scene = Player.instantiate()
		my_hand_scene.controller = self
		add_child(my_hand_scene)

	my_hand = cards
	my_hand_scene.cards = []
	for c in my_hand:
		my_hand_scene.cards.push_back(c)
	my_hand_scene.present()

@rpc("call_local", "any_peer", "reliable")
func play_card(pid: int, card: int):
	# Verify that it is pid's turn
	print("Attempting to play... %s" % card)
	if pid != game_state.current_player:
		print("Not your turn, player %s" % pid)
		return
	var curr = game_state.players.find_custom(func f(p): return p.id == pid)
	if curr != -1:
		var currp = game_state.players[curr]
		var cidx = currp.cards.find_custom(func f(c): return c.id == card)
		# Verify that pid has this card
		if cidx == -1:
			print("You don't have this card")
		else:
			# Remove card from pid's hand and re-render
			print("Player %s is playing this card" % pid)
			print(Cards.CARDS[card])
			# Put the card in the game area
			# Mark the new current player
			game_state.current_player = game_state.players[(curr + 1) % len(game_state.players)].id
