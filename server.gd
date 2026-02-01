extends Node

@export var lobby: Node
@export var board: Node

# Server State
# This stuff is only managed by the server instance (i.e., ID 1)
var game_state = {
	"players": [],
	"current_player": 1,
	"deck": [],
	"discard": [],
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
	game_state.discard = card_pile.new()
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
			"played": [],
			"score": 0,
		})

	game_state.deck.shuffle()

	deal_hands.rpc_id(1)

@rpc("call_local", "reliable")
func deal_hands():
	for p in game_state.players:
		p.cards = game_state.deck.take_from(5).map(func ids(c): return c.id)
		if len(p.cards) < 5:
			print("I'ma shuff", game_state.discard.size())
			# Draw deck is empty. Shuffle discard
			game_state.deck.draw_from(game_state.discard, game_state.discard.size())
			game_state.deck.shuffle()
			p.cards.append_array(game_state.deck.take_from(5 - len(p.cards)).map(func ids(c): return c.id))
		set_hand.rpc_id(p.id, p.cards)


@rpc("call_local", "any_peer", "reliable")
func test_spawn_card():
	var maybe_cards = game_state.deck.take_from(1)
	if len(maybe_cards):
		var card = maybe_cards[0]
		board.spawn(card.id)

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
			currp.cards.remove_at(cidx)
			currp.played.push_back(card)
			set_hand.rpc_id(pid, currp.cards)
			# Put the card in the game area
			board.spawn(card)
			# Check if the round is over
			var has_cards = func f(p) -> bool:
				return len(p.cards) > 0
			if game_state.players.find_custom(has_cards) == -1:
				# Round is over, no one has cards
				score_round.rpc_id(1)
				# TODO: If a player has enough points to win, transition to win screen
				var p1score = game_state.players[0].score
				var p2score = game_state.players[1].score
				if (p1score >= 5 or p2score >= 5 && p1score != p2score):
					# Someone won, but I don't know who yet
					var winner = 0 if p1score > p2score else 1
					declare_winner.rpc_id(1, winner)
				deal_hands.rpc_id(1)
			# Mark the new current player
			game_state.current_player = game_state.players[(curr + 1) % len(game_state.players)].id

@rpc("call_local", "reliable")
func score_round():
	# Derive the top, mid, and bottom stats of cards for each player
	var player_positions = game_state.players.map(derive_hand)
	# Compare across the players
	# There should only ever be two players game jam
	var p1 = player_positions[0]
	var p2 = player_positions[1]
	var p1score = 0
	var p2score = 0

	for slot in ["top", "middle", "bottom"]:
		if p1[slot] == CardSlot.ACTIONS.ATTACK and p2[slot] != CardSlot.ACTIONS.DEFEND:
			p1score += 1
		if p2[slot] == CardSlot.ACTIONS.ATTACK and p1[slot] != CardSlot.ACTIONS.DEFEND:
			p2score += 1

	game_state.players[0].score += p1score
	game_state.players[1].score += p2score
	print("Game score P1: %s, P2 %s" % [game_state.players[0].score, game_state.players[1].score])
	for p in game_state.players:
		print("Appending that whence was played ", len(p.played))
		for c in p.played:
			game_state.discard.add_card(carddb[c])
		p.played = []
	print("New discard length ", game_state.discard.size(), game_state.discard.cards.size(), len(game_state.discard.cards))
	board.clear()

@rpc("call_local", "reliable")
func declare_winner(winner):
	# Change the scene
	print("Player %s was won!!!!!" % winner)
	board.clear()


func derive_hand(p):
	var M = CardSlot.ACTIONS.MASK
	var top = M
	var middle = M
	var bottom = M
	for i in range(len(p.played) - 1, 0, -1):
		var c = carddb[p.played[i]]
		if top == M: top = c.top.action
		if middle == M: middle = c.middle.action
		if bottom == M: bottom = c.bottom.action
		if top != M and middle != M and bottom != M:
			# All slots resolved
			break

	return {
		"top": top,
		"middle": middle,
		"bottom": bottom,
	}
