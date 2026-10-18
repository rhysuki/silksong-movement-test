extends Node2D


@export var hittable: Hittable
@export var animation_player: AnimationPlayer


func _ready() -> void:
	$Hittable.on_hit.connect(func(type: Player.AttackType):
		if type == Player.AttackType.DOWN:
			animation_player.stop()
			animation_player.play("bounce")
	)
