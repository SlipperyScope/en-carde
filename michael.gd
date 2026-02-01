extends Node2D

const PORT = 1337

const EMP = 0
const ATK = 1
const DEF = 2
const EXP = 3

var cards = [
	{ "id": 1, "name": "Poop", "top": ATK, "mid": ATK, "bot": EMP },
	{ "id": 1, "name": "Pee", "top": DEF, "mid": EXP, "bot": EMP },
	{ "id": 1, "name": "Barf", "top": DEF, "mid": EMP, "bot": DEF },
	{ "id": 1, "name": "Burp", "top": EMP, "mid": ATK, "bot": EMP },
	{ "id": 1, "name": "Sneeze", "top": EMP, "mid": EMP, "bot": ATK },
]

var game_state = {
	"p1_cards": [],
	"p2_cards": [],
}

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	multiplayer.server_relay = false


func _on_host_pressed():
	print("POOP HOST")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	# On Error: Game Jam
	multiplayer.multiplayer_peer = peer
	start_game()

func _on_connect_pressed():
	print("POOP CLIENT")
	var peer = ENetMultiplayerPeer.new()
	var addr = $Menu/Buttons/Address.text
	if addr == "":
		OS.alert("Game jam? Address anyone??")
	peer.create_client(addr, PORT)
	multiplayer.multiplayer_peer = peer
	start_game()

func start_game():
	var Player = preload("res://michael_hand.tscn")

	$Menu.hide()
	get_tree().paused = false

	game_state.p1_cards.push_back(cards.pop_front())
	game_state.p1_cards.push_back(cards.pop_front())
	game_state.p2_cards.push_back(cards.pop_front())
	game_state.p2_cards.push_back(cards.pop_front())

	if multiplayer.is_server():
		var hand = Player.instantiate()
		for c in game_state.p1_cards:
			print(c)
			hand.cards.push_back(c)
		add_child(hand)
	else:
		var hand = Player.instantiate()
		for c in game_state.p2_cards:
			hand.cards.push_back(c)
		add_child(hand)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
