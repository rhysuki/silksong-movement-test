extends Node
## adjusts the position of Parallax2D nodes to match their in-editor appearance.
## specifically, when the Parallax2D's origin is at the center of the camera, it
## should look how it does in the editor.


func _ready() -> void:
	var p: Parallax2D = get_parent()
	p.scroll_offset *= p.scroll_scale
	# taking into account the viewport center? camera size? i'm not sure
	# ohhh. half camera size * scroll scale maybe?
	p.scroll_offset += p.get_viewport_rect().size * 0.5 * (Vector2(1.0, 1.0) - p.scroll_scale)
	p.ignore_camera_scroll = false
