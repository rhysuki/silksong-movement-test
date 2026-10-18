extends Area2D


func _ready() -> void:
	body_entered.connect(func(other: Node2D):
		other.global_position = $RespawnPoint.global_position
	)
