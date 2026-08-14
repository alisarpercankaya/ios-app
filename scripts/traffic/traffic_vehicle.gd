extends Node3D

var speed: float = 0.0  # absolute forward speed, same units as GameState.scroll_speed
var near_miss_scored: bool = false

@onready var hit_area: Area3D = $HitArea


func activate(lane_x: float, spawn_z: float, vehicle_speed: float) -> void:
	position = Vector3(lane_x, 0.0, spawn_z)
	speed = vehicle_speed
	near_miss_scored = false
	visible = true
	hit_area.monitorable = true
	set_physics_process(true)


func deactivate() -> void:
	# Pooled-but-inactive vehicles must stop being detectable, not just invisible:
	# an Area3D keeps reporting overlaps regardless of visibility or _physics_process,
	# so leaving one parked at the default (0,0,0) origin would false-trigger the
	# player's crash/near-miss zones the instant it's pooled.
	visible = false
	hit_area.monitorable = false
	position = Vector3(0.0, -500.0, 0.0)
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	position.z += (GameState.scroll_speed - speed) * delta
