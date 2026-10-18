extends RichTextEffect
class_name TypewriterEffect


const GRADIENT_ORANGE: Gradient = preload("res://scenes/ui/typewriter_label/orange_gradient.tres")
const GRADIENT_PURPLE: Gradient = preload("res://scenes/ui/typewriter_label/purple_gradient.tres")
const GRADIENT_PINK: Gradient = preload("res://scenes/ui/typewriter_label/pink_gradient.tres")

## For e.g. exported variables
enum GradientPreset {
	ORANGE,
	PURPLE,
	PINK
}

@export var print_speed: float = 40.0
@export var show_speed_multiplier: float = 0.08
@export var _skip: bool = false
@export var _start_offset: Vector2 = Vector2(8.0, 8.0)
## The gradient that'll be sampled for the text color as it animates in.
@export var color_gradient: Gradient
## The function that'll be sampled for the easing of the text offset as it animates in.
@export var _easing_curve: Curve
var bbcode: String = "typewriter"
var _elapsed: float = 0.0


func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	if _skip:
		char_fx.offset = Vector2.ZERO
		char_fx.color *= color_gradient.sample(1.0)
		return true

	_elapsed = char_fx.elapsed_time

	# I'm not sure why range is a Vector, both values seem to always be the same?
	var index := char_fx.range.x
	var elapsed := char_fx.elapsed_time * print_speed
	var unit = clampf((elapsed - index) * show_speed_multiplier, 0.0, 1.0)

	char_fx.offset += _start_offset.lerp(Vector2.ZERO, _easing_curve.sample(unit))
	char_fx.color *= color_gradient.sample(unit)

	return true


## Whether enough time has passed since this effect started (or resetted) that it's
## finished printing all the text in this string.
func is_done_printing(text: String) -> bool:
	# TextOld it takes to print out all characters + a few frames extra
	var needed: float = text.length() / print_speed + 0.01666 * 10.0
	return (_elapsed >= needed) or _skip


func skip() -> void:
	_skip = true


func restart() -> void:
	_elapsed = 0.0
	_skip = false


func set_gradient_to_preset(gradient_preset: GradientPreset) -> void:
	match gradient_preset:
		GradientPreset.ORANGE:
			color_gradient = GRADIENT_ORANGE
		GradientPreset.PURPLE:
			color_gradient = GRADIENT_PURPLE
		GradientPreset.PINK:
			color_gradient = GRADIENT_PINK
		_:
			push_error("Invalid gradient preset: %d" % gradient_preset)