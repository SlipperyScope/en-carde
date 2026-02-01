extends Control

@export var cards := []
@export var controller: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	present()
	pass

func t(v: int):
	return (v+1) % 4

func present():
	for c in %Tray.get_children():
		c.queue_free()
	render_cards()

func render_cards():
	var card_scene = preload("res://michael_card.tscn")

	for c in cards:
		var cd = controller.carddb[c]
		var cs = card_scene.instantiate() as Control
		var on_click = func():
			if controller == null:
				print("Woah, no controller")
			else:
				controller.play_card.rpc_id(1, multiplayer.get_unique_id(), c)
		cs.id = cd.id
		cs.label = cd.id
		cs.top = t(cd.top.action)
		cs.mid = t(cd.middle.action)
		cs.bot = t(cd.bottom.action)
		cs.find_child("Action").pressed.connect(on_click)
		%Tray.add_child(cs)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
