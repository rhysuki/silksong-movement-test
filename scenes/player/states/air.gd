extends Node
class_name PlayerAirState


@onready var p: Player = get_parent()
var is_manual_jump: bool = false
var is_spinning: bool = false
var is_dashing: bool = false
var has_dashed: bool = false
var _spin_animation: String = ""
var _jump_buffer_time: float = 0.0
var _first_frame: bool = true


func pick_random_spin_animation() -> void:
	_spin_animation = "spin" if randf() > 0.5 else "somersault"


func _input(event: InputEvent) -> void:
	if not p.is_input_enabled:
		return

	if event.is_action_pressed("confirm"):
		_jump_buffer_time = 0.0333 * 5.0

	if event.is_action_pressed("cancel"):
		if p.is_action_pressed("down"):
			p.try_down_attack()
		else:
			p.try_attack()

	if event.is_action_pressed("dash") and (not has_dashed):
		var dash = Game.spawn_particle(Game.particle_dash, p.global_position + Vector2(0.0, -4.0))
		dash.scale = p.facing_axis_vec
		is_dashing = true
		has_dashed = true
		_spin_animation = "single_flip"
		p.velocity.y = 0.0


func _physics_process(delta: float) -> void:
	if p.is_on_floor() and not _first_frame:
		if _jump_buffer_time > 0.0:
			if is_dashing and p.is_action_pressed("dash"):
				p.switch_state(p.dash_jump_windup_state)
			else:
				p.jump()
		else:
			p.switch_state(p.ground_state)
			Game.spawn_particle(Game.particle_dust, p.global_position)

			if is_dashing and p.is_action_pressed("dash"):
				p.state.state = PlayerGroundState.STATE_DASH


	if p.velocity.y >= 0.0 and p.can_ledge_climb():
		p.switch_state(p.ledge_climb_state)

	if is_manual_jump and p.velocity.y < 0.0 and (not p.is_action_pressed("confirm")):
		# NOTE: delta * 60.0 for _physics_process(), delta * 30.0 for _process()
		p.velocity.y = move_toward(p.velocity.y, 0.0, delta * 60.0 * 20.0)

	_jump_buffer_time -= delta * 2.0
	p.speed = p.BASE_SPEED * p.DASH_SPEED_MOD if is_dashing else p.BASE_SPEED
	p.move_horizontally(delta)
	p.apply_gravity(delta)
	p.move_and_slide()
	_first_frame = false

	if p.is_attacking:
		return

	if _spin_animation:
		p.play(_spin_animation)
		return

	if is_spinning:
		p.play("spin")
		return

	if is_dashing:
		p.play("long_jump" if p.velocity.y < 0 else "single_flip")
	else:
		p.play("jump" if p.velocity.y < 0 else "fall")
