extends Node


@onready var p: Player = get_parent()
var _time: float = Game.FRAME_TIME * 4.0


func _physics_process(delta: float) -> void:
	_time -= delta * 2.0
	p.play("fall")
	p.velocity = Vector2(p.BASE_SPEED * p.DASH_SPEED_MOD, 0.0) * p.facing_axis_vec

	p.move_and_slide()

	if _time < 0.0:
		p.jump()
		p.state.is_dashing = true
		process_mode = Node.PROCESS_MODE_DISABLED

		var particle = Game.spawn_particle(Game.particle_diagonal_slash, p.global_position + Vector2(0.0, -4.0))
		particle.scale = p.facing_axis_vec * Vector2(-1.0, 1.0)