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
