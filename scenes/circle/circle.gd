@tool
extends Node2D


@export var filled: bool = false
@export var radius: float = 5.0
@export var width: float = 1.0
@export var color: Color = Palette.WHITE


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color, filled, (-1.0 if filled else width))