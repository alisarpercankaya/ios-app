extends Node3D
## Pools traffic vehicles, spawns them ahead of the player on a randomized
## interval that tightens with distance, and returns them to the pool once
## they've scrolled past the player.

@export var vehicle_scene: PackedScene

var _pool: Array[Node3D] = []
var _active: Array[Node3D] = []
var _lane_last_vehicle: Dictionary = {}
var _spawn_timer: float = 0.0
var _next_interval: float = GameConfig.TRAFFIC_MAX_SPAWN_INTERVAL


func _ready() -> void:
	for i in GameConfig.TRAFFIC_POOL_SIZE:
		var v: Node3D = vehicle_scene.instantiate()
		add_child(v)
		v.deactivate()
		_pool.append(v)


func _physics_process(delta: float) -> void:
	if GameState.crashed:
		return

	_spawn_timer += delta
	if _spawn_timer >= _next_interval:
		_spawn_timer = 0.0
		_try_spawn()
		_next_interval = _current_spawn_interval()

	var i: int = _active.size() - 1
	while i >= 0:
		var v: Node3D = _active[i]
		if v.position.z > GameConfig.TRAFFIC_DESPAWN_Z:
			_active.remove_at(i)
			v.deactivate()
			_pool.append(v)
		i -= 1


func _current_spawn_interval() -> float:
	var t: float = clampf(GameState.distance / GameConfig.TRAFFIC_DIFFICULTY_RAMP_DISTANCE, 0.0, 1.0)
	var base: float = lerpf(GameConfig.TRAFFIC_MAX_SPAWN_INTERVAL, GameConfig.TRAFFIC_MIN_SPAWN_INTERVAL, t)
	return base * randf_range(0.8, 1.2)


func _try_spawn() -> void:
	if _pool.is_empty():
		return
	var lanes: Array[float] = GameConfig.LANE_XS.duplicate()
	lanes.shuffle()
	for lane_x in lanes:
		var last_vehicle: Node3D = _lane_last_vehicle.get(lane_x)
		if last_vehicle and is_instance_valid(last_vehicle) and last_vehicle.visible \
				and last_vehicle.position.z < GameConfig.TRAFFIC_SPAWN_Z + GameConfig.TRAFFIC_MIN_LANE_GAP:
			continue
		var vehicle: Node3D = _pool.pop_back()
		var relative_offset: float = randf_range(GameConfig.TRAFFIC_SPEED_VARIANCE_MIN, GameConfig.TRAFFIC_SPEED_VARIANCE_MAX)
		var vehicle_speed: float = maxf(GameState.scroll_speed + relative_offset, 2.0)
		vehicle.activate(lane_x, GameConfig.TRAFFIC_SPAWN_Z, vehicle_speed)
		_active.append(vehicle)
		_lane_last_vehicle[lane_x] = vehicle
		return
