extends Control

const LIQUID_SHADER = preload("res://scripts/resource_flask.gdshader")
var level := 1.0:
	set(value):
		level = clampf(value, 0.0, 1.0)
		if glass_material != null:
			glass_material.set_shader_parameter("fill_level", level)
var glass_material: ShaderMaterial
var value_label: Label
var fill_tween: Tween

func setup(kind: String, color: Color, bounds: Vector2) -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	var glass := TextureRect.new()
	add_child(glass)
	glass.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	glass.texture = load("res://assets/hud/%s_chamber.png" % kind)
	glass.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	glass.stretch_mode = TextureRect.STRETCH_SCALE
	glass.mouse_filter = Control.MOUSE_FILTER_IGNORE
	glass_material = ShaderMaterial.new()
	glass_material.shader = LIQUID_SHADER
	glass_material.set_shader_parameter("liquid_color", color)
	glass_material.set_shader_parameter("chamber_bounds", bounds)
	glass.material = glass_material
	var frame := TextureRect.new()
	add_child(frame)
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.texture = load("res://assets/hud/%s_frame.png" % kind)
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame.stretch_mode = TextureRect.STRETCH_SCALE
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	value_label = Label.new()
	add_child(value_label)
	value_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	value_label.anchor_top = 0.3
	value_label.anchor_bottom = 0.8
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value_label.add_theme_font_size_override("font_size", 18)
	value_label.add_theme_constant_override("outline_size", 5)
	value_label.add_theme_color_override("font_outline_color", Color(0.06, 0.02, 0.03))
	value_label.mouse_filter = Control.MOUSE_FILTER_IGNORE

func set_value(current: int, maximum: int, animated: bool = true) -> void:
	value_label.text = "%d" % current
	tooltip_text = "%d / %d" % [current, maximum]
	var target := clampf(float(current) / maximum, 0, 1) if maximum > 0 else 0.0
	if fill_tween != null:
		fill_tween.kill()
	if animated:
		fill_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		fill_tween.tween_property(self, "level", target, 0.35)
	else:
		level = target
