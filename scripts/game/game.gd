extends Node


## how long 1 tick lasts at 30fps
const FRAME_TIME: float = 1.0 / 30.0

@export var particle_circle: PackedScene
@export var particle_dust: PackedScene
@export var particle_slash: PackedScene
@export var particle_diagonal_slash: PackedScene
@export var particle_dash: PackedScene
@export var particle_hit: PackedScene
var player_input_lock := Lock.new()
var player: Player
var camera: Camera2D
var active_camera_limit: CameraLimit
var room: Node2D
var _camera_shake_intensity: float = 0.0
var _camera_shake_tween: Tween


func _physics_process(_delta: float) -> void:
	if _camera_shake_intensity > 0.0:
		camera.offset = Vector2(
			randf_range(-_camera_shake_intensity, _camera_shake_intensity),
			randf_range(-_camera_shake_intensity, _camera_shake_intensity)
		)


func freeze(node: Node, time_seconds: float) -> void:
	node.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	await wait(time_seconds)
	node.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)


func wait(seconds: float) -> void:
	var t := get_tree().create_timer(seconds)
	await t.timeout


func spawn_particle(particle_scene: PackedScene, global_position: Vector2) -> Node:
	var p: Node2D = particle_scene.instantiate()
	room.add_child(p)
	p.global_position = global_position

	return p


func shake_camera(duration_seconds: float = 0.4, intensity_pixels: float = 10.0) -> void:
	if not camera:
		camera = get_viewport().get_camera_2d()

	if _camera_shake_tween:
		_camera_shake_tween.kill()

	_camera_shake_tween = get_tree().create_tween()
	_camera_shake_tween.set_ease(Tween.EASE_OUT)
	_camera_shake_tween.set_trans(Tween.TRANS_CIRC)
	_camera_shake_intensity = intensity_pixels
	_camera_shake_tween.tween_property(self, "_camera_shake_intensity", 0.0, duration_seconds)
	await _camera_shake_tween.finished
	camera.offset = Vector2.ZERO


func rand_magnitude() -> float:
	return -1.0 if randf() > 0.5 else 1.0