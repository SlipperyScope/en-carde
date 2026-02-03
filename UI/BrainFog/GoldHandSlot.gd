extends PanelContainer
# UI element for cards in the player's hand
class_name GoldHandSlot

signal CardSlotBuilt(card: GoldHandSlot) ## Card slot has finished building
signal ExpandAnimationFinished(card: GoldHandSlot, position: ExpandTarget) ## Card finished expand/collapse animation
signal SelectAnimationFinished(card: GoldHandSlot, position: SlideTarget) ## Card finished select/deselect animation
signal SelectCard(card: GoldHandSlot) ## User attempting to select card
signal PlayCard(card: GoldHandSlot) ## User attempting to play card

const EXPAND_ANIMATION = "expand" ## Animation name in the player
const SLIDE_ANIMATION = "slide_up" ## Animation name in the player
const BUMP_MARKER = "bump_height" ## Marker name in the player
var BUMP_MARKER_TIME: float: ## Animation time of the bump marker
	get:
		return %SlideAnimation.get_animation(SLIDE_ANIMATION).get_marker_time(BUMP_MARKER)

## Where to slide to
enum SlideTarget {
	Down, ## Down position
	Partial, ## Mouseover position
	Full, ## Selected position
}

## Where to expand to
enum ExpandTarget {
	Expanded, ## Expanding open
	Collapsed ## Expanding closed
}

var _Selected: bool

## True: Card is selected
var Selected: bool:
	get: return _Selected

var _Expanded: bool

## True: Card is expanded
var Expanded: bool:
	get: return _Expanded

## Whether the card should animate on slide and expand
var DoAnimations: bool:
	get: return DoAnimations
	set(value):
		DoAnimations = value
		# Force complete current animations

## True if the card can be clicked / responds to mouse events
var Clickable: bool:
	get: return Clickable
	set(value): mouse_filter = Control.MouseFilter.MOUSE_FILTER_STOP if value == true else Control.MouseFilter.MOUSE_FILTER_IGNORE

## True if the mouse is over this slot
var _MouseOver: bool = false

func _ready():
	%SlideAnimation.assigned_animation = SLIDE_ANIMATION
	%ExpandAnimation.assigned_animation = EXPAND_ANIMATION
	Clickable = false
	mouse_entered.connect(_on_mouse_over)
	mouse_exited.connect(_on_mouse_out)
	gui_input.connect(_on_mouse_click)

## Set the initial configurion for the card
func Build(card: GoldCardInst, params: GoldHandSlotParams) -> void:
	if is_node_ready() == false:
		push_error("Tried to build hand slot before it was ready")
		return
	
	%CardBackground.texture = card.FrontTexture
	%CardGraphic.texture = card.GraphicTexture
	%TopStance.texture = card.TopStanceTexture
	%MiddleStance.texture = card.MiddleStanceTexture
	%BottomStance.texture = card.BottomStanceTexture

	DoAnimations = false
	%SlideAnimation.speed_scale = params.AnimationSpeed
	%ExpandAnimation.speed_scale = params.AnimationSpeed
	Clickable = params.StartClickable

	if params.StartCollapsed == true:
		Collapse(false)
	else:
		Expand(false)
	if params.StartSelected == true:
		Select(false)
	else:
		Deselect(false)

	DoAnimations = params.EnableAnimation
	CardSlotBuilt.emit(self )

## Select this card
func Select(fireEvent = true) -> void:
	_Selected = true
	if fireEvent == true:
		%SlideAnimation.animation_finished.connect(_on_select_animation_finished)
	_Slide(SlideTarget.Full, !DoAnimations, fireEvent)

## Handles select animation completion
func _on_select_animation_finished(_anim_name: String) -> void:
	%SlideAnimation.animation_finished.disconnect(_on_select_animation_finished)
	SelectAnimationFinished.emit(self , SlideTarget.Full)

## Deselect this card
func Deselect(fireEvent = true) -> void:
	_Selected = false
	var target: SlideTarget = SlideTarget.Down if _MouseOver == false else SlideTarget.Partial
	if fireEvent == true:
		%SlideAnimation.animation_finished.connect(_on_deselect_animation_finished)
	_Slide(target, !DoAnimations, fireEvent)

## Handles deselect animation completion
func _on_deselect_animation_finished(_anim_name: String) -> void:
	%SlideAnimation.animation_finished.disconnect(_on_deselect_animation_finished)
	SelectAnimationFinished.emit(self , SlideTarget.Full)

## Expand this card
func Expand(fireEvent = true) -> void:
	_Expanded = true
	if fireEvent == true:
		%ExpandAnimation.animation_finished.connect(_on_expand_animation_finished)
	_Expand(ExpandTarget.Expanded, !DoAnimations, fireEvent)

## Handles expand animation completion
func _on_expand_animation_finished(_anim_name: String) -> void:
	%ExpandAnimation.animation_finished.disconnect(_on_expand_animation_finished)
	ExpandAnimationFinished.emit(self , ExpandTarget.Expanded)

## Collapse this card
func Collapse(fireEvent = true) -> void:
	_Expanded = false
	if fireEvent == true:
		%ExpandAnimation.animation_finished.connect(_on_collapse_animation_finished)
	_Expand(ExpandTarget.Collapsed, !DoAnimations, fireEvent)

## Handles collapse animation completion
func _on_collapse_animation_finished(_anim_name: String) -> void:
	%ExpandAnimation.animation_finished.disconnect(_on_collapse_animation_finished)
	ExpandAnimationFinished.emit(self , ExpandTarget.Collapsed)

## Starts a card slide
func _Slide(to: SlideTarget, skipAnimation: bool = false, fireEvent: bool = true) -> void:
	var anim = %SlideAnimation
	
	var endTime: float
	match to:
		SlideTarget.Down:
			endTime = 0
		SlideTarget.Full:
			endTime = anim.current_animation_length
		SlideTarget.Partial:
			endTime = BUMP_MARKER_TIME

	if fireEvent == false:
		anim.seek(endTime, true)
		return

	var startTime = anim.current_animation_position if skipAnimation == false else endTime
	if startTime < endTime:
		anim.play_section(SLIDE_ANIMATION, startTime, endTime)
	elif startTime > endTime:
		anim.play_section_backwards(SLIDE_ANIMATION, endTime, startTime)
	else:
		anim.seek(endTime, true)
		anim.animation_finished.emit(SLIDE_ANIMATION)

## Starts a card expand
func _Expand(target: ExpandTarget, skipAnimation: bool = false, fireEvent: bool = true) -> void:
	var anim = %ExpandAnimation
	var endTime: float
	match target:
		ExpandTarget.Expanded:
			endTime = anim.current_animation_length
		ExpandTarget.Collapsed:
			endTime = 0
	
	if fireEvent == false:
		anim.seek(endTime, true)
		return

	var startTime = anim.current_animation_position if skipAnimation == false else endTime

	if startTime < endTime:
		anim.play_section(EXPAND_ANIMATION, startTime, endTime)
	elif startTime > endTime:
		anim.play_section_backwards(EXPAND_ANIMATION, endTime, startTime)
	else:
		anim.seek(endTime)
		anim.animation_finished.emit(EXPAND_ANIMATION)

## Handles mouse over
func _on_mouse_over() -> void:
	_MouseOver = true
	if Selected == false:
		_Slide(SlideTarget.Partial, !DoAnimations)

## Handles mouse out
func _on_mouse_out() -> void:
	_MouseOver = false
	if Selected == false:
		_Slide(SlideTarget.Down, !DoAnimations)

## Handles mouse click
func _on_mouse_click(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if Selected == true:
			PlayCard.emit(self )
		else:
			SelectCard.emit(self )
