extends Node2D

const PORT = 1337
signal letsago(players)

var max_players = 2
var players = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	multiplayer.server_relay = false
	multiplayer.peer_connected.connect(_on_pconnect)
	multiplayer.peer_disconnected.connect(_on_pdisconnect)

func _on_pconnect(pid):
	_register.rpc_id(pid)

func _on_pdisconnect(id):
	# I don't think this propagates, game jam
	players.erase(id)

@rpc("any_peer", "reliable")
func _register():
	var id = multiplayer.get_remote_sender_id()
	print("Got a connection %s" % id)
	players[id] = {
		"id": id,
	}

	print("Num players %s" % len(players))
	if multiplayer.is_server():
		if players.size() == max_players:
			start_game()

func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	# Server doesn't connect so manually make player 1
	players[1] = { "id": 1 }
	$Menu.hide()
	$Waiting.show()

func _on_connect_pressed():
	var peer = ENetMultiplayerPeer.new()
	var addr = $Menu/Buttons/Address.text
	if addr == "":
		OS.alert("Game jam? Address anyone?")
	peer.create_client(addr, PORT)
	multiplayer.multiplayer_peer = peer

@rpc("call_local")
func close_lobby():
	$Menu.hide()
	$Waiting.hide()

func start_game():
	close_lobby.rpc()
	letsago.emit(players)
