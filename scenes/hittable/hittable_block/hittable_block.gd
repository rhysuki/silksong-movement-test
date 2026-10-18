extends RigidBody2D


@onready var hit: Hittable = $Hittable


func _ready() -> void:
	hit.on_hit.connect(func(attack_type: Player.AttackType):
		Game.freeze(self, Game.FRAME_TIME * 2.0)

		linear_velocity = Vector2.ZERO

		if attack_type == Player.AttackType.UP:
			apply_impulse(Vector2(randf_range(-22.0, 22.0), randf_range(-80.0, -150.0)))
		elif attack_type == Player.AttackType.DOWN:
			apply_impulse(Vector2(0.0, 150.0))
		else:
			apply_impulse(Vector2(randf_range(50.0, 70.0), randf_range(-50.0, -150.0)) * Game.player.facing_axis_vec)

		apply_torque_impulse(randf_range(80.0, 150.0) * Game.player.facing_axis)

	)
