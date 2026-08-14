extends CharacterBody3D

const BASE_HANDLING: float = 10.0  # lateral units/sec^2 toward steer target, scaled by bike.handling_mult
const SPEED_LERP_RATE: float = 3.0  # how fast scroll_speed eases toward its target
const CRASH_REACTION_DELAY: float = 1.2

@onready var crash_hitbox: Area3D = $CrashHitbox
@onready var near_miss_zone: Area3D = $NearMissZone
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

var lane_x: float = 0.0
var lateral_velocity: float = 0.0
var bike: BikeData


func _ready() -> void:
	crash_hitbox.area_entered.connect(_on_crash_hitbox_area_entered)
	near_miss_zone.area_entered.connect(_on_near_miss_zone_area_entered)

	bike = BikeRoster.get_bike(SaveManager.selected_bike_id)
	if bike == null and not BikeRoster.bikes.is_empty():
		bike = BikeRoster.bikes[0]
	if bike != null:
		var mat := StandardMaterial3D.new()
		mat.albedo_color = bike.body_color
		mesh_instance.set_surface_override_material(0, mat)

	GameState.reset_run()


func _physics_process(delta: float) -> void:
	if GameState.crashed:
		velocity.y -= GameConfig.GRAVITY * delta
		move_and_slide()
		return

	if not is_on_floor():
		velocity.y -= GameConfig.GRAVITY * delta
	else:
		velocity.y = 0.0

	var handling: float = BASE_HANDLING * (bike.handling_mult if bike else 1.0)
	var steer: float = InputManager.get_steer_axis()
	var steer_target: float = steer * handling
	lateral_velocity = move_toward(lateral_velocity, steer_target, handling * 4.0 * delta)
	lane_x = clampf(lane_x + lateral_velocity * delta, -GameConfig.ROAD_HALF_WIDTH + 0.6, GameConfig.ROAD_HALF_WIDTH - 0.6)

	velocity.x = (lane_x - position.x) / delta if delta > 0.0 else 0.0
	velocity.z = 0.0

	var top_speed_mult: float = bike.top_speed_mult if bike else 1.0
	var accel_mult: float = bike.acceleration_mult if bike else 1.0
	var target_speed: float = GameConfig.BASE_FORWARD_SPEED * top_speed_mult
	if InputManager.is_boost_pressed():
		target_speed *= GameConfig.BOOST_SPEED_MULTIPLIER
	GameState.scroll_speed = move_toward(GameState.scroll_speed, target_speed, GameConfig.BASE_FORWARD_SPEED * SPEED_LERP_RATE * accel_mult * delta)
	GameState.distance += GameState.scroll_speed * delta

	move_and_slide()


func _on_crash_hitbox_area_entered(area: Area3D) -> void:
	if area.is_in_group("traffic"):
		_trigger_crash()


func _on_near_miss_zone_area_entered(area: Area3D) -> void:
	if not area.is_in_group("traffic"):
		return
	var vehicle: Node = area.get_parent()
	if vehicle and not vehicle.near_miss_scored:
		vehicle.near_miss_scored = true
		GameState.register_near_miss()


func _trigger_crash() -> void:
	if GameState.crashed:
		return
	GameState.trigger_crash()
	velocity.x = 0.0
	velocity.z = 0.0
	await get_tree().create_timer(CRASH_REACTION_DELAY).timeout
	get_tree().change_scene_to_file("res://scenes/gameplay/run_summary.tscn")
