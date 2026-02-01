extends PanelContainer
class_name Finger

signal card_selected(index:int)
signal card_played(index:int)

var is_selected:bool = false
var index:int = -1

func _ready() -> void:
	gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("clicked")
		if is_selected:
			card_played.emit(index)
		else:
			card_selected.emit(index)

func Select() -> void:
	is_selected = true
	%spacer.custom_minimum_size = Vector2(0, Global.SELECTED_CARD_OFFSET)

func Deselect() -> void:
	is_selected = false
	%spacer.custom_minimum_size = Vector2(0, 0)

func ConfigureCard(data:CardData) -> void:
	%bench_card.ConfigureCard(data)
