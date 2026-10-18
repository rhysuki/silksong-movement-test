extends CharacterBody2D
class_name Player
## TODO: put all the magic numbers somewhere sensible, like in consts?


signal refreshed_attack

enum AttackType {
	SIDE,
	UP,
	DOWN,
}

const FRAME_INDEX_ATTACK: int = 7
const FRAME_INDEX_ATTACK_UP: int = 8
const BASE_SPEED: float = 55.0
const DASH_SPEED_MOD: float = 1.85
const ATTACK_COOLDOWN_TIME: float = 0.85
const DOWN_ATTACK_COOLDOWN_TIME: float = 0.7
const TERMINAL_SPEED: float = 230.0

@export var speed: float = BASE_SPEED
@export var jump_strength: float = -200.0
@export var gravity: float = 10.0
@export var attack_cooldown: float = 0.0
@export var down_attack_cooldown: float = 0.0

@export var sprite: Sprite2D
@export var collision: CollisionShape2D
@export var label: Label
@export var animation_player: AnimationPlayer
@export var flip_node: Node2D
@export var ledge_area: Area2D
@export var above_ledge_area: Area2D
@export var camera: Camera2D
@export var side_attack_position: Node2D
@export var dash_particle_position: Node2D

@export var side_attack: PackedScene
@export var down_attack: PackedScene

@export var ground_state: PackedScene
@export var air_state: PackedScene
@export var ledge_climb_state: PackedScene
@export var down_attack_state: PackedScene
@export var dash_jump_windup_state: PackedScene

var state: Node
var is_facing_right: bool = true
var is_attacking: bool = false

var is_input_enabled: bool:
	get:
		return not Game.player_input_lock.is_locked()

var facing_axis: float:
	get:
		return 1.0 if is_facing_right else -1.0

var facing_axis_vec: Vector2:
	get:
		return Vector2(facing_axis, 1.0)


func _ready() -> void:
	Game.player = self
	Game.camera = camera
	switch_state(ground_state)
	camera.reset_smoothing()

	animation_player.animation_finished.connect(func(anim: String):
		if anim == "attack" or anim == "attack_up":
			is_attacking = false
	)


func _process(delta: float) -> void:
	$InputEnabledRect.visible = not is_input_enabled
	attack_cooldown -= delta * 2.0
	down_attack_cooldown -= delta * 2.0


func play(animation_name: String) -> void:
	animation_player.play(animation_name)


func move_horizontally(delta: float) -> void:
	var direction: float = get_input_axis()

	if direction:
		velocity.x = direction * speed * delta * 60.0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	if is_attacking:
		return

	if direction < 0:
		flip_node.scale.x = -1.0
		is_facing_right = false
	elif direction > 0:
		flip_node.scale.x = 1.0
		is_facing_right = true


func jump() -> void:
	velocity.y = jump_strength
	switch_state(air_state)
	state.is_manual_jump = true
	Game.spawn_particle(Game.particle_circle, global_position)


func try_attack() -> void:
	if attack_cooldown > 0.0:
		return

	attack_cooldown = ATTACK_COOLDOWN_TIME
	is_attacking = true
	var attack: Node2D = side_attack.instantiate()
	add_child(attack)
	attack.position = side_attack_position.position

	if Input.is_action_pressed("up"):
		attack.rotation = - PI / 2.0
		# flip it horizontally instead of vertically
		attack.scale.y = facing_axis
		attack.attack_type = AttackType.UP
		play("attack_up")
		sprite.frame = FRAME_INDEX_ATTACK_UP
	else:
		play("attack")
		attack.scale.x = facing_axis
		sprite.frame = FRAME_INDEX_ATTACK

	sprite.rotation = 0.0

	var t := get_tree().create_timer(attack_cooldown)
	t.timeout.connect(refreshed_attack.emit)


func try_down_attack() -> void:
	if down_attack_cooldown > 0.0:
		return

	down_attack_cooldown = DOWN_ATTACK_COOLDOWN_TIME
	state.process_mode = Node.PROCESS_MODE_DISABLED
	switch_state(down_attack_state)


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta * 60.0

		if velocity.y > TERMINAL_SPEED:
			velocity.y = move_toward(velocity.y, TERMINAL_SPEED, delta * 100.0 * 60.0)


func switch_state(new_state_scene: PackedScene) -> void:
	if state:
		if state.has_method("exit"):
			state.exit()

		state.queue_free()

	state = new_state_scene.instantiate()
	add_child(state)
	move_child(state, 0)

	if state.has_method("enter"):
		state.enter()

	# don't update the new state until next frame to avoid weird state-dances
	state.process_mode = Node.PROCESS_MODE_DISABLED
	state.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)


func can_ledge_climb() -> bool:
	var axis: float = get_input_axis()
	return (axis - facing_axis == 0.0) \
		and ledge_area.has_overlapping_bodies() \
		and (not above_ledge_area.has_overlapping_bodies())


func spawn_dash_particle() -> void:
	Game.spawn_particle(Game.particle_circle, dash_particle_position.global_position)
	Game.spawn_particle(Game.particle_dust, dash_particle_position.global_position)


func is_action_pressed(action: String) -> bool:
	if is_input_enabled:
		return Input.is_action_pressed(action)

	return false


func get_input_axis() -> float:
	if is_input_enabled:
		return Input.get_axis("left", "right")

	return 0.0
