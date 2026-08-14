extends CanvasLayer

@onready var margin: MarginContainer = $Margin
@onready var distance_label: Label = $Margin/DistanceLabel
@onready var status_label: Label = $Margin/StatusLabel


func _ready() -> void:
	get_viewport().size_changed.connect(_apply_safe_margins)
	_apply_safe_margins()


func _apply_safe_margins() -> void:
	var safe_margin: Vector2 = GameConfig.get_safe_area_margin(get_viewport())
	margin.add_theme_constant_override("margin_left", 24 + int(safe_margin.x))
	margin.add_theme_constant_override("margin_right", 24 + int(safe_margin.x))
	margin.add_theme_constant_override("margin_top", 24 + int(safe_margin.y))
	margin.add_theme_constant_override("margin_bottom", 24 + int(safe_margin.y))


func _process(_delta: float) -> void:
	distance_label.text = "Distance: %d m   Near-misses: %d" % [int(GameState.distance), GameState.near_miss_count]
	status_label.text = "CRASHED! +%d coins - restarting..." % GameState.coins_this_run if GameState.crashed else ""
