extends Panel


@export var is_hornet_visible: bool = true:
	set(value):
		_hornet_head.visible = value
	get:
		return _hornet_head.visible

@export var is_needle_visible: bool = true:
	set(value):
		_needle.visible = value
	get:
		return _needle.visible

@export var _hornet_head: Sprite2D
@export var _needle: Sprite2D
