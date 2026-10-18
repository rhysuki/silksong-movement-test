/*
Naive way to limit colors to a palette, based on
https://forum.godotengine.org/t/limit-games-color-palette/3470/2.

Ideally we'd like it to work like Aseprite's indexing filter, where it's good at
retaining a lot of the detail and contrast between colors, but Aseprite uses a
complicated algorithm that isn't trivially replicable.

For now, an adjusted version of human perception color weights is enough to bring
it much, much closer to Aseprite's, but it's still hard to get the exact intricacies
down. You might need to make micro-adjustments for each specific palette (and you
should do that anyway to maximize clarity). However, nothing will beat manual adjustments
at getting just the right colors.

https://github.com/aseprite/aseprite/blob/fc63532fef3b75d95759d93dab2b5622d5a12b6d/src/render/ordered_dither.cpp#L126

Remember BackBufferCopy can be used to overlay screen-reading shaders on top of
one another.
 */

shader_type canvas_item;
render_mode blend_mix;

// If true, will read screen colors from under it instead of the current texture.
uniform bool is_screen_shader = true;
uniform sampler2D palette: filter_nearest;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_nearest;

uniform float r_weight: hint_range(0.0, 0.5) = 0.22;
uniform float g_weight: hint_range(0.0, 0.8) = 0.4;
uniform float b_weight: hint_range(0.0, 0.5) = 0.07;

vec4 weigh(vec4 color) {
	return vec4(
		color.r * r_weight,
		color.g * g_weight,
		color.b * b_weight,
		color.a
	);
}

void fragment()
{
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);

	if (is_screen_shader)
	{
		color = texture(SCREEN_TEXTURE, SCREEN_UV);
	}
	else
	{
		color = texture(TEXTURE, UV);
	}

	int palette_width = textureSize(palette, 0).x;
	vec4 closest_color = vec4(0.0);

	for (int x = 0; x < palette_width; x++)
	{
		float palette_pixel_size = 1.0 / float(palette_width);
		float x_coordinate = float(x) * palette_pixel_size;
		vec4 palette_color = texture(palette, vec2(x_coordinate, 0.0));
		vec4 weighed_color = weigh(color);

		if (distance(weighed_color, weigh(palette_color)) < distance(weighed_color, weigh(closest_color)))
		{
			closest_color = palette_color;
		}
	}

	COLOR.rgb = closest_color.rgb;
}
