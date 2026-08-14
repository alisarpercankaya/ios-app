extends Node3D
## Pools road segments and recycles them from behind the player to ahead of it,
## so the road appears endless without ever instancing/freeing at runtime.

@export var segment_scene: PackedScene

# A segment must not recycle until its FRONT edge (not just its trailing edge)
# has scrolled past the player. Segments are contiguous, so the next segment
# only starts covering z=0 once the current one's front edge reaches z=0 -
# recycling any earlier (e.g. once merely the trailing edge passes the player,
# as traffic vehicles do) opens a gap in the road right under the player.
const RECYCLE_BUFFER: float = 5.0

var _segments: Array[Node3D] = []
var _front_z: float = 0.0


func _ready() -> void:
	_front_z = -GameConfig.ROAD_SEGMENT_LENGTH * 0.5
	for i in GameConfig.ROAD_SEGMENT_COUNT:
		var seg: Node3D = segment_scene.instantiate()
		add_child(seg)
		seg.position.z = _front_z
		_segments.append(seg)
		_front_z -= GameConfig.ROAD_SEGMENT_LENGTH


func _physics_process(delta: float) -> void:
	if GameState.crashed:
		return
	var move: float = GameState.scroll_speed * delta
	for seg in _segments:
		seg.position.z += move
		if seg.position.z - GameConfig.ROAD_SEGMENT_LENGTH * 0.5 > RECYCLE_BUFFER:
			seg.position.z = _front_z
			_front_z -= GameConfig.ROAD_SEGMENT_LENGTH
