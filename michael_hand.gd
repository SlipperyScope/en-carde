extends Node2D

@export var cards := []


# Called when the node enters the scene tree for the first time.
func _ready():
	var card_scene = preload("res://michael_card.tscn")
	for c in cards:
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
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
