extends Node


@onready var p: Player = get_parent()


func _ready() -> void:
	await Game.wait(Game.FRAME_TIME * 3.0)
	p.jump()
	p.state.is_spinning = true
	p.velocity.x = p.speed * p.facing_axis

	if p.is_action_pressed("dash"):
		p.state.is_dashing = true


func _physics_process(_delta: float) -> void:
	p.play("jump")
	p.is_attacking = false
	p.velocity = Vector2.ZERO
	p.move_and_slide()
