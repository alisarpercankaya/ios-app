extends CanvasLayer
## Repositions the boost button relative to the current viewport so it stays
## in the bottom-right corner (inset from the safe area) across resolutions
## and orientation changes, since TouchScreenButton has no anchor system.

@onready var boost_button: TouchScreenButton = $BoostButton

const MARGIN: float = 140.0


func _ready() -> void:
	get_viewport().size_changed.connect(_reposition)
	_reposition()


func _reposition() -> void:
	var vp_size: Vector2 = get_viewport().get_visible_rect().size
	var safe_margin: Vector2 = GameConfig.get_safe_area_margin(get_viewport())
	boost_button.position = Vector2(
		vp_size.x - MARGIN - safe_margin.x,
		vp_size.y - MARGIN - safe_margin.y
	)
