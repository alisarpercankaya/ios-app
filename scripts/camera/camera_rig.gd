extends Node3D
## Chase camera: lerps toward a follow target instead of being parented to it,
## so bike jitter doesn't transfer 1:1 into the view.

@export var target_path: NodePath
@export var local_offset: Vector3 = Vector3(0.0, 2.2, 5.0)
@export var look_ahead: Vector3 = Vector3(0.0, 0.8, -6.0)
@export var follow_speed: float = 6.0

@onready var camera: Camera3D = $Camera3D

var _target: Node3D


func _ready() -> void:
	if target_path != NodePath():
		_target = get_node(target_path)


func _process(delta: float) -> void:
	if _target == null:
		return
	var desired_position: Vector3 = _target.global_position + local_offset
	global_position = global_position.lerp(desired_position, 1.0 - exp(-follow_speed * delta))
	camera.look_at(_target.global_position + look_ahead, Vector3.UP)
