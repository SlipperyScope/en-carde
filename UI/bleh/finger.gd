extends PanelContainer
class_name Finger

signal card_selected(index:int)
signal card_played(index:int)

var is_selected:bool = false
var index:int = -1
var cardID:String = "xxx"
var _canPlay:bool = false

func _ready() -> void:
	gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_selected:
			card_played.emit(index)
		else:
			card_selected.emit(index)

func Select() -> void:
	is_selected = true
	%spacer.custom_minimum_size = Vector2(0, Global.SELECTED_CARD_OFFSET)
	SetCanPlay(_canPlay)

func Deselect() -> void:
	is_selected = false
	%spacer.custom_minimum_size = Vector2(0, 0)
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func SetCanPlay(canPlay:bool) -> void:
	_canPlay = canPlay
	if is_selected:
		if _canPlay:
			mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		else:
			mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN

func ConfigureCard(data:CardData) -> void:
	%bench_card.ConfigureCard(data)

func SetCardID(id:String) -> void:
	print("setting id to %s" % id)
	cardID = id