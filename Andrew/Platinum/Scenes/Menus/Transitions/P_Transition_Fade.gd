## Fades a control using alpha modulation
class_name P_Transition_Fade extends P_Transition

signal FadedOut() ## Emitted when fade out is complete (content is invisible)
signal FadedIn() ## Emitted when fade in is complete (content is visible)

@export var FadeChildren: bool = true ## Whether to fade child controls as well
@export var FadeoutTime: float = 0.1 ## Time in seconds to fade
@export var FadeinTime: float = 0.1 ## Time in seconds to fade

var _PropTarget: String:
	get: return "%smodulate:a" % ("_self" if FadeChildren == false else "")

var _Target: Node = null

## Assigns a persistant target so you don't need to pass it to the Fade functions every time
func AssignTarget(target: Node) -> void:
	_Target = target

## Fades the target out using alpha modulation
func FadeOut(target: Node = null) -> void:
	if target == null:
		if _Target == null:
			push_warning("No target assigned to transition")
			FadedOut.emit()
			return
		else:
			target = _Target
	else:
		var tween := target.create_tween()
		tween.tween_property(target, _PropTarget, 0.0, FadeoutTime)
		tween.finished.connect(func(): FadedOut.emit())

## Fades the target in using alpha modulation
func FadeIn(target: Node = null) -> void:
	if target == null:
		if _Target == null:
			push_warning("No target assigned to transition")
			FadedIn.emit()
			return
		else:
			target = _Target
	else:
		var tween := target.create_tween()
		tween.tween_property(target, _PropTarget, 1.0, FadeinTime)
		tween.finished.connect(func(): FadedIn.emit())
