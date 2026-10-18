extends Node2D


@export var area: Area2D
@export var hit_position: Node2D
var attack_type := Player.AttackType.SIDE
var already_hit: Array[Hittable]


func _ready() -> void:
	area.area_entered.connect(func(other):
		if other is Hittable:
			if other in already_hit:
				return

			already_hit.append(other)
			other.hit(attack_type)
			Game.freeze(Game.player, Game.FRAME_TIME * 3.0)
			Game.spawn_particle(Game.particle_slash, hit_position.global_position)
			Game.spawn_particle(Game.particle_hit, hit_position.global_position)
	)
