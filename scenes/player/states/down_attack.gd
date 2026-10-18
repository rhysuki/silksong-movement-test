extends Node


const attack_type := Player.AttackType.DOWN

@onready var p: Player = get_parent()
var windup_speed := Vector2(20.0, 20.0)
var speed := Vector2(120.0, 120.0)
var time_until_end: float = 0.0
var attack


func _ready() -> void:
	p.play("attack")

	var facing_axis_vec := Vector2(p.facing_axis, 1.0)
	p.velocity = windup_speed * facing_axis_vec

	await Game.wait(Game.FRAME_TIME * 3.0)
	var particle = Game.spawn_particle(
		Game.particle_diagonal_slash,
		p.global_position + Vector2(0.0, -4.0)
	)
	particle.sprite.flip_h = not p.is_facing_right
	p.play("dive")
	p.velocity = speed * facing_axis_vec

	attack = p.down_attack.instantiate()
	p.add_child(attack)
	attack.scale.x = p.facing_axis
	attack.area.area_entered.connect(func(other):
		if other is Hittable:
			other.hit(attack_type)
			Game.freeze(p, Game.FRAME_TIME * 2.0)
			Game.spawn_particle(Game.particle_dust, p.global_position)
			Game.spawn_particle(Game.particle_hit, p.global_position)
			Game.spawn_particle(Game.particle_circle, p.global_position)

			var slash = Game.spawn_particle(Game.particle_slash, p.global_position)
			# cherry is really cool and sexy :3
			slash.scale = Vector2(0.75, 0.75)

			p.switch_state(p.air_state)

			if attack:
				attack.queue_free()

			if particle:
				particle.queue_free()

			if other.is_bouncy:
				p.velocity.y = p.jump_strength
				p.state.pick_random_spin_animation()
	)

	time_until_end = Game.FRAME_TIME * 5.0


func _physics_process(delta: float) -> void:
	if p.is_on_floor():
		if attack:
			attack.queue_free()

		p.switch_state(p.ground_state)

	if time_until_end > 0.0:
		time_until_end -= delta

	if time_until_end < 0.0:
		p.switch_state(p.air_state)

	p.move_and_slide()
