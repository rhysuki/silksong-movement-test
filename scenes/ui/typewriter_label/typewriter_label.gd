extends RichTextLabel
class_name TypewriterLabel


signal finished_printing

@export var _voice_timer: Timer

var is_done: bool:
	get:
		return effect.is_done_printing(get_parsed_text())

## Makes sure `finished_printing` only gets emitted once per display.
var _emitted_finished_printing: bool = false
@onready var voice: AudioStreamPlayer
@onready var effect: TypewriterEffect = custom_effects[0]


func _ready() -> void:
	_voice_timer.timeout.connect(func():
		if voice:
			voice.pitch_scale = 1.0 + randf() * 0.05
			voice.play()
	)


func _process(_delta: float) -> void:
	if is_done:
		_voice_timer.stop()

		if not _emitted_finished_printing:
			finished_printing.emit()
			_emitted_finished_printing = true


func display(new_text: String) -> void:
	reset()
	text = "[typewriter]" + new_text


func skip() -> void:
	effect.skip()


func reset() -> void:
	# This cannot be the best way to reset a RichTextEffect's timer
	text += " "
	text = text.substr(0, text.length() - 1)
	effect.restart()
	_voice_timer.start()
	_emitted_finished_printing = false
