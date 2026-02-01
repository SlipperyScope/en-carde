extends Control

@export var server: Node

var card_scene = preload("res://michael_card.tscn")

func t(v: int):
	return (v+1) % 4

# Tell the server to spawn a card
func _on_spawn():
	server.test_spawn_card.rpc_id(1)

# Render the card the server tells us to
func spawn(id):
	var card = card_scene.instantiate()
	var cd = server.carddb[id]
	# var cd = id

	card.id = cd.id
	card.label = cd.id
	card.top = t(cd.top.action)
	card.mid = t(cd.middle.action)
	card.bot = t(cd.bottom.action)

	%Cards.add_child(card, true)

func clear():
	for c in %Cards.get_children():
		c.queue_free()
