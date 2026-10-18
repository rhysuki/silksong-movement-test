extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.room = self


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_restart"):
		Game.player.global_position = $PlayerRespawn.global_position