extends CanvasLayer


@export var text_box: TextBox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_box.visible = false
