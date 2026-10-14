extends Control

const BAR_SHADER = preload("res://scripts/portrait_status.gdshader")
const PORTRAIT_SHADER = preload("res://scripts/portrait_circle.gdshader")
var life_level := 1.0:
	set(value):
		life_level = clampf(value, 0, 1)
		if life_material != null:
			life_material.set_shader_parameter("fill_level", life_level)
var mana_level := 1.0:
	set(value):
		mana_level = clampf(value, 0, 1)
		if mana_material != null:
			mana_material.set_shader_parameter("fill_level", mana_level)
var life_material: ShaderMaterial
var mana_material: ShaderMaterial
var life_label: Label
var mana_label: Label
var life_tween: Tween
var mana_tween: Tween
var mirrored := false

func setup(portrait: Texture2D, opposite: bool = false) -> void:
	mirrored = opposite
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var portrait_rect := TextureRect.new()
	add_child(portrait_rect)
	_set_region(portrait_rect, Rect2(0.060021, 0.210719, 0.215031, 0.492082))
	portrait_rect.texture = portrait
	if portrait == null:
		var blank := Image.create(1, 1, false, Image.FORMAT_RGBA8)
		blank.fill(Color.WHITE)
		portrait_rect.texture = ImageTexture.create_from_image(blank)
	portrait_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	portrait_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	var portrait_material := ShaderMaterial.new()
	portrait_material.shader = PORTRAIT_SHADER
	portrait_material.set_shader_parameter("has_portrait", portrait != null)
	portrait_rect.material = portrait_material
	if portrait == null:
		var placeholder := Label.new()
		add_child(placeholder)
		_set_region(placeholder, Rect2(0.060021, 0.210719, 0.215031, 0.492082))
		placeholder.text = "?"
		placeholder.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		placeholder.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		placeholder.add_theme_font_size_override("font_size", 28)
	life_material = _bar("life", Color(0.92, 0.04, 0.07), Vector2(0.336639, 0.939457))
	mana_material = _bar("mana", Color(0.04, 0.38, 1.0), Vector2(0.327244, 0.946764))
	var frame := TextureRect.new()
	add_child(frame)
	frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	frame.texture = load("res://assets/hud/portrait_bars_frame.png")
	frame.flip_h = opposite
	frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	frame.stretch_mode = TextureRect.STRETCH_SCALE
	frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	life_label = _counter(Rect2(0.336639, 0.220463, 0.602818, 0.196102))
	mana_label = _counter(Rect2(0.327244, 0.529842, 0.619520, 0.165651))

func _set_region(node: Control, rect: Rect2) -> void:
	node.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	node.anchor_left = 1.0 - rect.end.x if mirrored else rect.position.x
	node.anchor_right = 1.0 - rect.position.x if mirrored else rect.end.x
	node.anchor_top = rect.position.y
	node.anchor_bottom = rect.end.y
	node.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _bar(kind: String, color: Color, bounds: Vector2) -> ShaderMaterial:
	var bar := TextureRect.new()
	add_child(bar)
	bar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bar.texture = load("res://assets/hud/%s_bar_mask.png" % kind)
	bar.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bar.stretch_mode = TextureRect.STRETCH_SCALE
	bar.flip_h = mirrored
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var material := ShaderMaterial.new()
	material.shader = BAR_SHADER
	material.set_shader_parameter("liquid_color", color)
	material.set_shader_parameter("bar_bounds", bounds)
	bar.material = material
	return material

func _counter(rect: Rect2) -> Label:
	var label := Label.new()
	add_child(label)
	_set_region(label, rect)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_constant_override("outline_size", 4)
	label.add_theme_color_override("font_outline_color", Color(0.03, 0.02, 0.01))
	return label

func set_life(current: int, maximum: int, animated: bool = true) -> void:
	life_label.text = "%d / %d" % [current, maximum]
	var target := clampf(float(current) / maximum, 0, 1) if maximum > 0 else 0.0
	if life_tween != null:
		life_tween.kill()
	if animated:
		life_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		life_tween.tween_property(self, "life_level", target, 0.35)
	else:
		life_level = target

func set_mana(current: int, maximum: int, animated: bool = true) -> void:
	mana_label.text = "%d / %d" % [current, maximum]
	var target := clampf(float(current) / maximum, 0, 1) if maximum > 0 else 0.0
	if mana_tween != null:
		mana_tween.kill()
	if animated:
		mana_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		mana_tween.tween_property(self, "mana_level", target, 0.35)
	else:
		mana_level = target
