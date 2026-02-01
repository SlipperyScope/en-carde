extends Node2D

@export var cards := []

# Called when the node enters the scene tree for the first time.
func _ready():
	present()
	pass

func present():
	var card_scene = preload("res://michael_card.tscn")
	# for c in get_children():
	# 	c.queue_free()
	while len(%Tray.get_children()):
		%Tray.get_child(0).free()

	for c in cards:
		print(c)
		var cs = card_scene.instantiate() as Control
		var on_click = func():
			print("Pressed %s cardbb" % c.name)
		cs.id = c.id
		cs.label = c.name
		cs.top = c.top
		cs.mid = c.mid
		cs.bot = c.bot
		cs.find_child("Action").pressed.connect(on_click)
		%Tray.add_child(cs)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
