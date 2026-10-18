extends Node2D


@export_multiline() var _text: String
@export var _area: Area2D


func _ready() -> void:
	_area.body_entered.connect(func(_other): Ui.text_box.open(_text))
	_area.body_exited.connect(func(_other): Ui.text_box.close())
