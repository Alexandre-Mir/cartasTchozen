shader_type spatial;
render_mode diffuse_burley;
uniform vec4 base_color : source_color = vec4(0.15, 0.105, 0.075, 1.0);
void fragment() {
	float grain = sin(UV.x * 120.0 + sin(UV.y * 32.0) * 2.0) * 0.008;
	float broad = sin(UV.x * 19.0 + UV.y * 3.0) * 0.012;
	ALBEDO = base_color.rgb + vec3(grain + broad);
	ROUGHNESS = 0.84;
}
