extends Node


@onready var p: Player = get_parent()
var _coyote_enabled: bool = true
var _coyote_time: float = 0.0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm"):
		pass

	if event.is_action_pressed("cancel"):
		pass


func _physics_process(delta: float) -> void:
	_coyote_time -= delta * 2.0