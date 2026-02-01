extends Node2D

var _can_draw:bool = true
var _has_discarded:bool = false
var _controller:ServerTwoPointOh = null
var _pendingPlayCardID:String = "xxx"
var _cardIDs:Array[String] = []
var _playIsAllowed:bool = false

func _ready() -> void:
	# Wire Server
	%server_two_point_oh.game_started.connect(_on_game_started)
	%server_two_point_oh.deal_card.connect(_on_card_dealt)
	%server_two_point_oh.hand_ready.connect(_on_hand_ready)
	%server_two_point_oh.test_play_card_answer.connect(_on_test_play_card_answer)

	# Wire UI
	%bench.card_selected.connect(_on_card_selected)
	%bench.card_drawn.connect(_on_card_drawn)
	%bench.card_activated.connect(_on_card_activated)

func _on_game_started(controller:ServerTwoPointOh) -> void:
	_controller = controller
	%bench.visible = true

func _on_card_dealt(id:String) -> void:
	_cardIDs.append(id)
	%bench.AddCardToHand(_controller.carddb[id])

func _on_card_selected(index:int) -> void:
	_controller.test_play_card.rpc_id(1, multiplayer.get_unique_id(), _pendingPlayCardID)

func _on_hand_ready() -> void:
	pass

func _on_card_drawn() -> void:
	pass

func _on_card_activated(index:int) -> void:
	_controller.play_card.rpc_id(1, multiplayer.get_unique_id(), _cardIDs[index])
	_on_test_play_card_answer(false)

func _on_test_play_card_answer(canPlay: bool) -> void:
	_playIsAllowed = canPlay
	%bench.AllowPlay(canPlay)
	if canPlay:
		pass
		# Animate card
	else:
		pass # wiggle card or something idk
