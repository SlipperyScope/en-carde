extends PanelContainer

var _fingerScene:PackedScene = preload("res://UI/bleh/finger.tscn")

signal card_selected(index:int)
signal card_activated(index:int)
signal card_drawn()

var _fingers:Array[Finger] = []
var _canPlay:bool = false

func _ready() -> void:
	%draw_pile_hit_area.mouse_entered.connect(_on_draw_pile_mouse_entered)
	%draw_pile_hit_area.mouse_exited.connect(_on_draw_pile_mouse_exited)
	%draw_pile_hit_area.gui_input.connect(_on_draw_pile_gui_input)

	%discard_pile_hit_area.mouse_entered.connect(_on_discard_pile_mouse_entered)
	%discard_pile_hit_area.mouse_exited.connect(_on_discard_pile_mouse_exited)
	%discard_pile_hit_area.gui_input.connect(_on_discard_pile_gui_input)

	%draw_pile_texture.custom_minimum_size = Vector2(Global.CARD_WIDTH, Global.CARD_HEIGHT)
	%draw_pile_buffer.custom_minimum_size = Vector2(Global.CARD_WIDTH, Global.CARD_HEIGHT)
	%discard_pile_texture.custom_minimum_size = Vector2(Global.CARD_WIDTH, Global.CARD_HEIGHT)
	%discard_pile_buffer.custom_minimum_size = Vector2(Global.CARD_WIDTH, Global.CARD_HEIGHT)

func SetDrawCount(count:int) -> void:
	pass

func SetDiscardCount(count:int) -> void:
	pass

# Creates finger with card and adds it to the bench
func AddCardToHand(data:CardData) -> void:
	var finger = _fingerScene.instantiate() as Finger
	%finger_container.add_child(finger)
	finger.index = _fingers.size()
	finger.SetCardID(data.id)
	_fingers.append(finger)
	finger.ConfigureCard(data)
	finger.card_selected.connect(_on_card_selected)
	finger.card_played.connect(_on_card_played)

func SetCardAt(index:int, data:CardData) -> void:
	_fingers[index].ConfigureCard(data)

func AllowPlay(canPlay:bool) ->void:
	_canPlay = canPlay
	for finger in _fingers:
		finger.SetCanPlay(canPlay)

# Clicked on card slot the frist time
func _on_card_selected(index:int) -> void:
	for finger in _fingers:
		if finger.index == index:
			finger.Select()
			card_selected.emit(index)
		else:
			finger.Deselect()

# Clicked on card slot the second time
func _on_card_played(index:int) -> void:
	card_activated.emit(index)

# draw pile signals

func _on_draw_pile_mouse_entered() -> void:
	pass

func _on_draw_pile_mouse_exited() -> void:
	pass

func _on_draw_pile_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		card_drawn.emit()

# discard pile signals

func _on_discard_pile_mouse_entered() -> void:
	pass

func _on_discard_pile_mouse_exited() -> void:
	pass

func _on_discard_pile_gui_input(event: InputEvent) -> void:
	pass
