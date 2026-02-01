extends HBoxContainer

signal stack_clicked()

var _cardClipperScene:PackedScene = preload("res://UI/CardClipper.tscn")

var _cardsToShow:int = 4
var _clippers:Array[CardClipper] = []
var _mouseIsOver:bool = false

func _ready() -> void:
	gui_input.connect(_on_gui_input)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and _mouseIsOver:
		stack_clicked.emit()

func _on_mouse_entered() -> void:
	_mouseIsOver = true

func _on_mouse_exited() -> void:
	_mouseIsOver = false

func AddCard(cardInstance:UICard) -> void:
	if _clippers.size() != 0:
		_clippers[-1].SetClipping(true)
	_addClipper(cardInstance, false)
	if _clippers.size() > _cardsToShow:
		remove_child(_clippers[-5])

# removes a card from the stack and returns it
func DrawCard() -> UICard:
	if _clippers.size() == 0:
		return null
	var clipper = _clippers.pop_back()
	var card = clipper.getCard()
	clipper.remove_child(card)
	remove_child(clipper)
	card.SetFaceUp(true)
	return card

func _addClipper(card:UICard, isClipping:bool) -> void:
	var clipper = _cardClipperScene.instantiate() as CardClipper
	_clippers.append(clipper)
	add_child(clipper)
	clipper.AddCard(card)
	clipper.SetClipping(isClipping)
	card.SetFaceUp(false)
