extends Node2D


func play(animation_name: String) -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play(animation_name)
