extends Area2D


@export var rect: ColorRect


func _ready() -> void:
	body_entered.connect(func(__):
		rect.visible = false
	)
