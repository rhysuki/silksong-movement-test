extends Node2D


var window_scale: int = 1
@onready var screen_size: Vector2 = get_viewport_rect().size
@onready var _viewport: Viewport = get_viewport()
@onready var _window = get_window()


func _ready():
	set_window_scale(4)


func _input(_event):
	if Input.is_action_just_pressed("debug_increase_window_scale"):
		set_window_scale(window_scale + 1)
	elif Input.is_action_just_pressed("debug_decrease_window_scale"):
		set_window_scale(window_scale - 1)
	elif Input.is_action_just_pressed("debug_quit"):
		get_tree().quit()


func set_window_scale(i: int):
	var delta: int = window_scale - i

	window_scale = max(1, i)
	_window.size = screen_size * window_scale
	_window.position += Vector2i(screen_size * 0.5 * delta)


## Convert an in-game position to a screen viewport position, considering the
## currently active Camera if there is one.
func get_screen_position(pos: Vector2) -> Vector2:
	var camera: Camera2D = _viewport.get_camera_2d()

	if camera:
		return camera.get_target_position() - screen_size / 2 + pos
	else:
		return pos
