extends PanelContainer
# UI element for cards in the player's hand
class_name GoldHandSlot

signal SelectCard(selectedCard: GoldHandSlot) # Notifies when the card should be selected
signal PlayCard(selectedCard: GoldHandSlot) # Notifies when the selected card should be played

const CARD_BUMP_TIME: float = 0.05

var _MouseOver: bool = false
var _lastAnimationFinishedTime: float = 0

func _ready():
	%SlideAnimation.assigned_animation = "bump_up"
	%SlideAnimation.seek(0, true)
	%SlideAnimation.animation_finished.connect(_on_animation_finished)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)


var IsSelected: bool:
	get:
		return IsSelected
	set(new_value):
		if IsSelected != new_value:
			IsSelected = new_value
			if %SlideAnimation.assigned_animation == "bump_up":
				%SlideAnimation.assigned_animation = "slide_up"
				%SlideAnimation.seek(_lastAnimationFinishedTime * 2)
			else:
				%SlideAnimation.assigned_animation = "slide_up"
				%SlideAnimation.seek(_lastAnimationFinishedTime)
			if new_value == true:
				%SlideAnimation.play("slide_up")
			else:
				%SlideAnimation.play_backwards("slide_up")

func _on_mouse_entered() -> void:
	_MouseOver = true
	if IsSelected == false && %SlideAnimation.current_animation != "slide_up":
		%SlideAnimation.play("bump_up")

func _on_mouse_exited() -> void:
	_MouseOver = false
	if IsSelected == false && %SlideAnimation.current_animation != "slide_up":
		%SlideAnimation.play_backwards("bump_up")

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if IsSelected == true:
			PlayCard.emit(self )
		else:
			SelectCard.emit(self )
		# IsSelected = !IsSelected

func _on_animation_finished(anim_name: String) -> void:
	_lastAnimationFinishedTime = %SlideAnimation.current_animation_position
	if %SlideAnimation.assigned_animation == "slide_up" && _MouseOver == true && _lastAnimationFinishedTime == 0:
		%SlideAnimation.play("bump_up")
