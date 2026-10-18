extends Parallax2D


func _ready() -> void:
	scroll_offset *= scroll_scale
	# taking into account the viewport center? camera size? i'm not sure
	# ohhh. half camera size * scroll scale maybe?
	scroll_offset += get_viewport_rect().size * 0.5 * (Vector2(1.0, 1.0) - scroll_scale)