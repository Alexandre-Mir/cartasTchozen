extends Control

var life_value: Label
var mana_value: Label

func setup(portrait: Texture2D, _opposite: bool = false) -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bust := TextureRect.new()
	add_child(bust)
	bust.position = Vector2.ZERO
	bust.size = Vector2(110, 140)
	bust.texture = portrait
	bust.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bust.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	bust.mouse_filter = Control.MOUSE_FILTER_IGNORE
	life_value = _counter("VIDA", 32, Color(0.88, 0.16, 0.19))
	mana_value = _counter("MANA", 96, Color(0.18, 0.48, 0.95))

func _counter(title: String, top: float, color: Color) -> Label:
	var box := Panel.new()
	add_child(box)
	box.position = Vector2(98, top)
	box.size = Vector2(56, 56)
	box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.035, 0.045, 0.06, 0.95)
	style.border_color = color
	style.set_border_width_all(2)
	box.add_theme_stylebox_override("panel", style)
	var caption := Label.new()
	box.add_child(caption)
	caption.position = Vector2(2, 5)
	caption.size = Vector2(52, 16)
	caption.text = title
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.add_theme_font_size_override("font_size", 12)
	caption.add_theme_color_override("font_color", color.lightened(0.3))
	caption.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var value := Label.new()
	box.add_child(value)
	value.position = Vector2(2, 20)
	value.size = Vector2(52, 34)
	value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value.add_theme_font_size_override("font_size", 28)
	value.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return value

func set_life(current: int, maximum: int, _animated: bool = true) -> void:
	life_value.text = str(current)
	life_value.tooltip_text = "Vida: %d/%d" % [current, maximum]

func set_mana(current: int, maximum: int, _animated: bool = true) -> void:
	mana_value.text = str(current)
	mana_value.tooltip_text = "Mana: %d/%d" % [current, maximum]
