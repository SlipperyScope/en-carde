extends Node2D

const PORT = 1337

# Client State
var my_hand = []
var my_hand_scene: Node

# Server State
var max_players = 2
var game_state = {
	"players_loaded": 0,
	"players": [],
	"current_player": 0,
	"deck": [],
}

# Called when the node enters the scene tree for the first time.
func _ready():
	# get_tree().paused = true
	multiplayer.server_relay = false
	multiplayer.peer_connected.connect(_on_pconnect)
	multiplayer.peer_disconnected.connect(_on_pdisconnect)

func _on_pconnect(pid):
	_register.rpc_id(pid)

@rpc("any_peer", "reliable")
func _register():
	var id = multiplayer.get_remote_sender_id()
	print("Got a connection %s" % id)
	game_state.players.push_back({
		"id": id,
		"cards": [],
	})
	print("Num players %s" % len(game_state.players))
	if multiplayer.is_server():
		if len(game_state.players) == max_players:
			start_game()

func _on_pdisconnect(id):
	var idx = game_state.players.find(id)
	if idx != -1:
		game_state.players.splice.remove_at(idx)

# TODO: Handshake things and game logic should get separated
func _on_host_pressed():
	print("POOP HOST")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	# On Error: Game Jam
	multiplayer.multiplayer_peer = peer
	# Server doesn't connect so manually make player 1
	game_state.players.push_back({
		"id": 1,
		"cards": [],
	})

func _on_connect_pressed():
	print("POOP CLIENT")
	var peer = ENetMultiplayerPeer.new()
	var addr = $Menu/Buttons/Address.text
	if addr == "":
		OS.alert("Game jam? Address anyone??")
	peer.create_client(addr, PORT)
	multiplayer.multiplayer_peer = peer


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
		add_child(my_hand_scene)

	my_hand = cards
	my_hand_scene.cards = []
	for c in my_hand:
		my_hand_scene.cards.push_back(c)
	my_hand_scene.present()

func start_game():
	print("Starting game!")
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

	render_game.rpc()


@rpc("call_local")
func render_game():
	$Menu.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
