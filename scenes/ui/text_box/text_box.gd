class_name TextBox
extends Node2D


@export var _label: RichTextLabel
@onready var _anim: AnimationPlayer = $AnimationPlayer


func open(text: String) -> void:
	_label.text = text
	_anim.stop()
	_anim.play("open")


func close() -> void:
	_anim.stop()
	_anim.play("close")
