extends Control

const CARD_SCENE = preload("res://scenes/card.tscn")
var preview: Card

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var shade := ColorRect.new()
	add_child(shade)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0, 0, 0, 0.45)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gui_input.connect(_on_overlay_input)
	resized.connect(_fit_preview)
	hide()

func open_card(source: Card) -> void:
	close()
	preview = CARD_SCENE.instantiate()
	add_child(preview)
	preview.can_drag = false
	# Hidden cards must never pass their data to the preview.
	if not source.face_down and source.data != null:
		preview.setup(source.data)
	preview.set_face_down(source.face_down)
	if not source.face_down:
		preview.set_details_visible(true)
	_ignore_mouse(preview)
	show()
	_fit_preview()

func _ignore_mouse(node: Node) -> void:
	if node is Control:
		node.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for child in node.get_children():
		_ignore_mouse(child)

func _fit_preview() -> void:
	if not is_instance_valid(preview):
		return
	var factor := maxf(0.1, minf(1.5, minf(size.x * 0.85 / 336.0, size.y * 0.85 / 468.0)))
	preview.scale = Vector2.ONE * factor
	preview.position = (size - Vector2(336, 468) * factor) / 2.0

func close() -> void:
	hide()
	if is_instance_valid(preview):
		preview.free()
	preview = null

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if (event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE) or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT):
		close()
		get_viewport().set_input_as_handled()

func _on_overlay_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_instance_valid(preview) and not preview.get_global_rect().has_point(get_global_mouse_position()):
			close()
		accept_event()
