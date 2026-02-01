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
	var card_scene = preload("res://michael_card.tscn")
	while len(%Tray.get_children()):
		%Tray.get_child(0).free()

	for c in cards:
		print(c)
		var cd = controller.carddb[c]
		print(cd)
		var cs = card_scene.instantiate() as Control
		var on_click = func():
			if controller == null:
				print("Woah, no controller")
			else:
				print("Pressed %s cardbb" % c)
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
