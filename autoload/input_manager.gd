extends Node
## Platform-agnostic input: touch-drag steering (with mouse-emulated-touch on
## desktop) falls back to keyboard when no drag is active.

var _drag_active: bool = false
var _drag_start_x: float = 0.0
var _drag_current_x: float = 0.0
const DRAG_RANGE_PX: float = 200.0


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			_drag_active = true
			_drag_start_x = event.position.x
			_drag_current_x = event.position.x
		else:
			_drag_active = false
	elif event is InputEventScreenDrag:
		_drag_current_x = event.position.x


func get_steer_axis() -> float:
	if _drag_active:
		var delta_px: float = _drag_current_x - _drag_start_x
		return clampf(delta_px / DRAG_RANGE_PX, -1.0, 1.0)
	return Input.get_axis("steer_left", "steer_right")


func is_boost_pressed() -> bool:
	return Input.is_action_pressed("boost")
