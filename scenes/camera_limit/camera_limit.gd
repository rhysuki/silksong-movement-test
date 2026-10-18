@icon("res://assets/images/icons/camera_limit.svg")
extends Area2D
class_name CameraLimit
## An Area2D that changes the limit of the currently active Camera2D to its own
## dimensions on contact.


@export var _collision: CollisionShape2D
@onready var _collision_rect: Rect2 = _collision.shape.get_rect()
var _player: Player
var _camera: Camera2D


func _ready() -> void:
	_camera = get_viewport().get_camera_2d()

	body_entered.connect(func(__):
		_camera = get_viewport().get_camera_2d()

		if _camera:
			_set_camera_limit(_camera)
			_player = Game.player
	)


func _physics_process(_delta: float) -> void:
	if not _player:
		return

	var area_rect = _collision_rect
	var player_rect = _player.collision.shape.get_rect()
	area_rect.position += _collision.position + global_position
	player_rect.position += _player.collision.position + _player.global_position


	# If this area fully encloses the player, activate it no matter what.
	# This prevents situations where the player touches another area then backs
	# off without re-triggering this BodyEntered event.
	if area_rect.encloses(player_rect):
		_set_camera_limit(_camera)


func _set_camera_limit(camera: Camera2D) -> void:
	# I'm not sure why I need THIS to prevent the Camera's limit from updating. Does
	# it update every time it's accessed, not when it's changed? I don't know. But
	# it works, so leave it alone!
	if Game.active_camera_limit == self:
		return

	var is_first_limit = camera.limit_left == -10000000
	var pos: Vector2 = _collision.global_position + _collision_rect.position
	var end: Vector2 = _collision.global_position + _collision_rect.end
	# Still not sure whether explicit or implicit types are more readable
	var left: int = pos.x as int
	var right: int = end.x as int
	var top: int = pos.y as int
	var bottom: int = end.y as int

	# Bail if it's resetting to the same CameraLimit
	if (camera.limit_left == left and camera.limit_right == right
		and camera.limit_top == top and camera.limit_bottom == bottom):
		return

	Game.active_camera_limit = self

	camera.limit_left = left
	camera.limit_right = right
	camera.limit_top = top
	camera.limit_bottom = bottom

	if is_first_limit:
		camera.reset_smoothing()
