extends Control
class_name Card

signal drag_started(card: Card)
signal drag_ended(card: Card, drop_position: Vector2)
signal inspect_requested(card: Card)

@onready var card_type: TextureRect = %CardImage
@onready var resource_label: Label = %ResourceLabel
@onready var name_label: Label = %NameLabel
@onready var cost_label: Label = %CostLabel
@onready var art_texture: TextureRect = %CardArt
@onready var type_label: Label = %TypeLabel
@onready var description_label: Label = %DescriptionLabel

var face_down := false
var can_drag := true
var back_panel: Panel
var description_box: Panel
var details_tween: Tween

var data: CardData
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO
var placement_tween: Tween
var hand_position := Vector2.ZERO
var hand_rotation := 0.0
var hand_scale := Vector2.ONE
var hand_order := 0
var hand_hovered := false
var hover_direction := -1.0

func animate_hand_pose(duration: float = 0.16) -> void:
	if placement_tween != null:
		placement_tween.kill()
	z_index = 100 if hand_hovered else hand_order
	var target_position := hand_position + Vector2(0, 18.0 * hover_direction if hand_hovered else 0.0)
	scale = hand_scale
	placement_tween = create_tween().set_parallel(true)
	placement_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	placement_tween.tween_property(self, "position", target_position, duration)
	placement_tween.tween_property(self, "rotation_degrees", hand_rotation, duration)

func setup(p_data: CardData) -> void:
	data = p_data
	_update_visuals()

func _update_visuals() -> void:
	if not data:
		return
	name_label.text = data.card_name
	cost_label.text = str(data.cost)
	type_label.text = data.type_name
	description_label.text = data.description
	resource_label.text = "%d/%d" % [data.attack, data.health]
	if data.art:
		art_texture.texture = data.art
	if data.type_frame:
		card_type.texture = data.type_frame

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if not dragging:
			inspect_requested.emit(self)
			accept_event()
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not can_drag or face_down or not PlayerState.can_player_act:
				return
			dragging = true
			if placement_tween != null:
				placement_tween.kill()
			rotation_degrees = 0
			drag_offset = global_position - get_global_mouse_position()
			drag_started.emit(self)

func _unhandled_input(event: InputEvent) -> void:
	if dragging and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			_end_drag()

func _process(_delta: float) -> void:
	if dragging:
		# Safety fallback if mouse button is released outside window or capture missed
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_end_drag()
			return
		global_position = get_global_mouse_position() + drag_offset

func _end_drag() -> void:
	if not dragging:
		return
	dragging = false
	drag_ended.emit(self, get_global_mouse_position())

func _ready() -> void:
	for child in card_type.get_children():
		if child is Control:
			child.mouse_filter = Control.MOUSE_FILTER_IGNORE
	description_box = Panel.new()
	card_type.add_child(description_box)
	description_box.position = Vector2(25, 295)
	description_box.size = Vector2(286, 114)
	description_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var description_style := StyleBoxFlat.new()
	description_style.bg_color = Color(0.90, 0.87, 0.78)
	description_style.set_border_width_all(1)
	description_style.border_color = Color(0.30, 0.25, 0.20)
	description_box.add_theme_stylebox_override("panel", description_style)
	description_label.reparent(description_box)
	description_label.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	description_label.position = Vector2(8, 7)
	description_label.size = Vector2(270, 100)
	description_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	type_label.size.x = 230
	set_details_visible(false, false)
	back_panel = Panel.new()
	back_panel.size = Vector2(336, 468)
	back_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.18, 0.30)
	style.set_border_width_all(6)
	style.border_color = Color(0.55, 0.65, 0.82)
	back_panel.add_theme_stylebox_override("panel", style)
	add_child(back_panel)
	var label := Label.new()
	back_panel.add_child(label)
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	label.text = "TCHOZEN"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 36)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_face_down(face_down)

func set_face_down(value: bool) -> void:
	face_down = value
	if is_instance_valid(back_panel):
		back_panel.visible = value
		card_type.visible = not value
	mouse_filter = Control.MOUSE_FILTER_STOP

func set_details_visible(value: bool, animated: bool = true) -> void:
	if details_tween != null:
		details_tween.kill()
	var art_bottom := 261.0 if value else 396.0
	var type_position := Vector2(25, 264 if value else 400)
	if not animated:
		art_texture.offset_bottom = art_bottom
		type_label.position = type_position
		description_box.visible = value
		description_box.modulate.a = 1.0 if value else 0.0
		return
	description_box.show()
	details_tween = create_tween().set_parallel(true)
	details_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	details_tween.tween_property(art_texture, "offset_bottom", art_bottom, 0.24)
	details_tween.tween_property(type_label, "position", type_position, 0.24)
	details_tween.tween_property(description_box, "modulate:a", 1.0 if value else 0.0, 0.18).set_delay(0.1 if value else 0.0)
	if not value:
		details_tween.chain().tween_callback(description_box.hide)
