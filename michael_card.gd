extends Control

@export var id := 1
@export var label := "Poop"
@export var top := 2
@export var mid := 1
@export var bot := 0

var colors = [
	'00000000',
	'ef3134',
	'4ec5ee',
	'a78278',
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = label
	$Top.color = colors[top]
	$Mid.color = colors[mid]
	$Bot.color = colors[bot]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
