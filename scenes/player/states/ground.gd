extends Node
class_name PlayerGroundState


enum {
	STATE_NORMAL,
	STATE_DASH,
	STATE_DASH_RECOIL,
}

@onready var p: Player = get_parent()
var state: int = STATE_NORMAL
var _backturn_timer: float = 0.0
var _coyote_enabled: bool = true
var _coyote_time: float = 0.0
var _dash_recoil_time: float = 0.0


func _input(event: InputEvent) -> void:
	if not p.is_input_enabled:
		return

	if event.is_action_pressed("confirm"):
		if state == STATE_DASH or (state == STATE_DASH_RECOIL and p.velocity.x != 0):
			p.switch_state(p.dash_jump_windup_state)
		else:
			p.jump()

		state = STATE_NORMAL
		_coyote_enabled = false

	if event.is_action_pressed("cancel"):
		if p.attack_cooldown <= 0.0 and state == STATE_DASH:
			state = STATE_NORMAL

		p.try_attack()

	if event.is_action_pressed("dash") and p.velocity.x != 0 and state != STATE_DASH and state != STATE_DASH_RECOIL:
		var dash = Game.spawn_particle(Game.particle_dash, p.global_position + Vector2(0.0, -4.0))
		dash.scale = p.facing_axis_vec
		state = STATE_DASH
		_backturn_timer = 0.0

	if event.is_action_released("dash") and state == STATE_DASH:
		state = STATE_NORMAL


func _physics_process(delta: float) -> void:
	_coyote_time -= delta * 2.0
	_dash_recoil_time -= delta * 2.0
	_backturn_timer -= delta

	if state == STATE_DASH and p.velocity.x == 0.0:
		stop_dash()

	if state == STATE_DASH_RECOIL:
		p.speed = p.BASE_SPEED * p.DASH_SPEED_MOD * 0.85
	elif state == STATE_DASH:
		p.speed = p.BASE_SPEED * p.DASH_SPEED_MOD
	else:
		p.speed = p.BASE_SPEED

	if state == STATE_DASH_RECOIL and _dash_recoil_time <= 0.0:
		if p.is_action_pressed("dash") and p.velocity.x != 0.0:
			state = STATE_DASH
		else:
			state = STATE_NORMAL

	if state == STATE_DASH and not p.is_action_pressed("dash"):
		stop_dash()

	if p.is_on_floor():
		_coyote_time = Game.FRAME_TIME * 3.0
	elif _coyote_time < 0.0 and _coyote_enabled:
		p.switch_state(p.air_state)

		if state == STATE_DASH:
			p.state.is_dashing = true
			p.state._spin_animation = "single_flip"

	var was_facing_right: bool = p.is_facing_right
	p.move_horizontally(delta)
	p.apply_gravity(delta)
	p.move_and_slide()

	if p.is_attacking:
		return

	if p.is_facing_right != was_facing_right:
		if state != STATE_NORMAL:
			stop_dash()

		_backturn_timer = Game.FRAME_TIME * 7.0

	if p.velocity.x == 0:
		_backturn_timer = 0.0

	if _backturn_timer > 0.0:
		p.play("backturn")
		return

	if state == STATE_DASH_RECOIL:
		p.play("fall")
		return

	var anim = "dash" if state == STATE_DASH else "walk"

	if p.velocity.x == 0:
		if p.is_action_pressed("up"):
			p.play("look_up")
		elif p.is_action_pressed("down"):
			p.play("look_down")
		else:
			p.play("idle")
	else:
		p.play(anim)


func stop_dash() -> void:
	state = STATE_DASH_RECOIL
	_dash_recoil_time = Game.FRAME_TIME * 10.0
