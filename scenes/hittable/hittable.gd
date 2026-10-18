extends Area2D
class_name Hittable


signal on_hit(attack_type: Player.AttackType)

@export var is_bouncy: bool = true


func hit(attack_type: Player.AttackType = Player.AttackType.SIDE):
	on_hit.emit(attack_type)