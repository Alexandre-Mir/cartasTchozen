shader_type canvas_item;
uniform vec4 liquid_color : source_color = vec4(0.8, 0.03, 0.08, 1.0);
uniform float fill_level : hint_range(0.0, 1.0) = 1.0;
uniform vec2 chamber_bounds = vec2(0.2, 0.85);

void fragment() {
	float mask = texture(TEXTURE, UV).r;
	float surface = mix(chamber_bounds.y, chamber_bounds.x, fill_level);
	float wave = (sin(UV.x * 23.0 + TIME * 1.6) + sin(UV.x * 37.0 - TIME)) * 0.003;
	float liquid = smoothstep(surface + wave - 0.003, surface + wave + 0.003, UV.y);
	if (fill_level <= 0.0) { liquid = 0.0; }
	if (fill_level >= 1.0) { liquid = 1.0; }
	float shine = pow(max(0.0, 1.0 - abs(UV.x - 0.32) * 13.0), 4.0);
	vec3 fluid = liquid_color.rgb * mix(1.15, 0.45, UV.y);
	float meniscus = exp(-abs(UV.y - surface - wave) * 190.0) * liquid;
	vec3 glass = vec3(0.18, 0.24, 0.28) + shine * 0.32;
	vec3 color = mix(glass, fluid + shine * 0.3 + meniscus * 0.18, liquid);
	COLOR = vec4(color, mask * mix(0.42 + shine * 0.15, 0.96, liquid));
}
