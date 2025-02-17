shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1);
uniform float line_thickness : hint_range(0, 25) = 1.0;
uniform vec4 body_colour : source_color = vec4(1);

void fragment() {
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;

	float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
	outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
	outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
	outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
	outline = min(outline, 1.0);

	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, line_color, outline - color.a);

	// Colour body
	if (texture(TEXTURE, UV).a == 1.) {
		vec4 main_texture = texture(TEXTURE, UV);
		vec4 final_output = main_texture;
		final_output.rgb = mix((main_texture.rgb*body_colour.rgb), (main_texture.rgb*body_colour.rgb), 1);
		COLOR = final_output;
	}
}
