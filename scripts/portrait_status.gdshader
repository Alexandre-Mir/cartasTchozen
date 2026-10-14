shader_type canvas_item;
uniform vec4 liquid_color : source_color = vec4(0.9, 0.04, 0.07, 1.0);
uniform float fill_level : hint_range(0.0, 1.0) = 1.0;
uniform vec2 bar_bounds = vec2(0.33, 0.94);
void fragment() {
	float mask = texture(TEXTURE, UV).r;
	float end = mix(bar_bounds.x, bar_bounds.y, fill_level);
	float wave = sin(UV.y * 48.0 + TIME * 1.6) * 0.0015;
	float filled = 1.0 - smoothstep(end + wave - 0.002, end + wave + 0.002, UV.x);
	if (fill_level <= 0.0) { filled = 0.0; }
	if (fill_level >= 1.0) { filled = 1.0; }
	vec3 liquid = liquid_color.rgb * (0.70 + 0.25 * sin(UV.y * 19.0));
	vec3 color = mix(vec3(0.07, 0.09, 0.11), liquid, filled);
	COLOR = vec4(color, mask * 0.96);
}
