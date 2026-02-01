extends PanelContainer

var _fingerScene:PackedScene = preload("res://UI/bleh/finger.tscn")

signal card_activated(index:int)
signal card_drawn()

var _fingers:Array[Finger] = []

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

	for i in range(Global.CARDS_IN_HAND):
		var finger = _fingerScene.instantiate() as Finger
		finger.index = i
		%finger_container.add_child(finger)
		_fingers.append(finger)
		finger.card_selected.connect(_on_card_selected)
		finger.card_played.connect(_on_card_played)

func SetDrawCount(count:int) -> void:
	pass

func SetDiscardCount(count:int) -> void:
	pass

func SetCardAt(index:int, data:CardData) -> void:
	_fingers[index].ConfigureCard(data)

# finger signals

func _on_card_selected(index:int) -> void:
	print("card selected")
	for finger in _fingers:
		if finger.index == index:
			finger.Select()
		else:
			finger.Deselect()

func _on_card_played(index:int) -> void:
	print("card played")
	card_activated.emit(index)

# draw pile signals

func _on_draw_pile_mouse_entered() -> void:
	pass

func _on_draw_pile_mouse_exited() -> void:
	pass

func _on_draw_pile_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		card_drawn.emit()
		print("draw pile clicked")

# discard pile signals

func _on_discard_pile_mouse_entered() -> void:
	pass

func _on_discard_pile_mouse_exited() -> void:
	pass

func _on_discard_pile_gui_input(event: InputEvent) -> void:
	pass
