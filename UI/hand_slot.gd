extends PanelContainer
class_name HandSlot

signal slot_clicked_twice()

var IsSelected: bool = false
var MouseIsOver: bool = false
var _childCard:UICard = null

func SetSelected(selected: bool) -> void:
    IsSelected = selected
    if selected:
        %offsetter.custom_minimum_size = Vector2(0, Global.SELECTED_CARD_OFFSET)
    else:
        %offsetter.custom_minimum_size = Vector2(0, 0)

func _ready() -> void:
    $click_area.gui_input.connect(_on_gui_input)
    $click_area.mouse_entered.connect(_on_mouse_entered)
    $click_area.mouse_exited.connect(_on_mouse_exited)

func _on_gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and MouseIsOver:
        SetSelected(!IsSelected)

func _on_mouse_entered() -> void:
    MouseIsOver = true

func _on_mouse_exited() -> void:
    MouseIsOver = false

func AddCard(cardInstance:UICard) -> void:
    if cardInstance == _childCard:
        print("card already set")
        return

    if _childCard != null:
        %card_container.remove_child(_childCard)
        _childCard.queue_free()
    
    _childCard = cardInstance
    %card_container.add_child(cardInstance)