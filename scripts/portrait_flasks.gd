extends Control

const FLASK = preload("res://scripts/resource_flask.gd")
var life_flask: Control
var mana_flask: Control

func setup(portrait: Texture2D, opposite: bool = false) -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	var bust := TextureRect.new()
	add_child(bust)
	bust.position = Vector2(40, 0)
	bust.size = Vector2(140, 140)
	bust.texture = portrait
	bust.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bust.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	bust.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if portrait == null:
		var placeholder := Label.new()
		add_child(placeholder)
		placeholder.position = Vector2(40, 0)
		placeholder.size = Vector2(140, 140)
		placeholder.text = "?"
		placeholder.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		placeholder.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		placeholder.add_theme_font_size_override("font_size", 42)
		placeholder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	life_flask = _flask("life", 0 if not opposite else 140, Color(0.90, 0.03, 0.07), Vector2(0.17703, 0.78230))
	mana_flask = _flask("mana", 140 if not opposite else 0, Color(0.03, 0.38, 1.0), Vector2(0.26077, 0.79107))

func _flask(kind: String, left: float, color: Color, bounds: Vector2) -> Control:
	var flask = FLASK.new()
	add_child(flask)
	flask.position = Vector2(left, 64)
	flask.size = Vector2(80, 80)
	flask.z_index = 2
	flask.setup(kind, color, bounds)
	return flask

func set_life(current: int, maximum: int, animated: bool = true) -> void:
	life_flask.set_value(current, maximum, animated)

func set_mana(current: int, maximum: int, animated: bool = true) -> void:
	mana_flask.set_value(current, maximum, animated)
