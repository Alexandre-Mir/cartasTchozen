shader_type canvas_item;
uniform bool has_portrait = true;
void fragment() {
	vec4 source = texture(TEXTURE, UV);
	float circle = 1.0 - smoothstep(0.49, 0.5, length(UV - vec2(0.5)));
	vec3 color = mix(vec3(0.09, 0.11, 0.15), source.rgb, source.a);
	if (!has_portrait) { color = vec3(0.09, 0.11, 0.15); }
	COLOR = vec4(color, circle);
}
