extends Control
class_name Card

signal drag_started(card: Card)
signal drag_ended(card: Card, drop_position: Vector2)

@onready var card_type: TextureRect = %CardImage
@onready var resource_label: Label = %ResourceLabel
@onready var name_label: Label = %NameLabel
@onready var cost_label: Label = %CostLabel
@onready var art_texture: TextureRect = %CardArt
@onready var type_label: Label = %TypeLabel
@onready var description_label: Label = %DescriptionLabel

var face_down := false
var back_panel: Panel

var data: CardData
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

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
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if face_down or not PlayerState.can_player_act:
				return
			dragging = true
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
	var background := ColorRect.new()
	background.color = Color(0.82, 0.80, 0.73)
	background.size = Vector2(336, 468)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)
	move_child(background, 0)
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
	mouse_filter = Control.MOUSE_FILTER_IGNORE if value else Control.MOUSE_FILTER_STOP
