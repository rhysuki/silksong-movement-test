@tool
extends Node

@export_file("*.txt") var hex_path: String
@export_tool_button("Run") var run_button = run

func run() -> void:
	if not FileAccess.file_exists(hex_path):
		push_error("Couldn't find '%s'." % hex_path)

	var colors: PackedColorArray = []

	for line: String in FileAccess.get_file_as_string(hex_path).split("\n"):
		if line != "":
			colors.append(Color(line.strip_edges()))

	var palette := ColorPalette.new()
	palette.colors = colors

	var palette_path: String = hex_path.get_basename() + ".tres"
	ResourceSaver.save(palette, palette_path)
	print("Saved %d colors to %s." % [colors.size(), palette_path])
