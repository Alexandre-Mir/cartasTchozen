extends Control

@onready var hand: Control = $Hand
@onready var player_field: HBoxContainer = $Board/PlayerField
@onready var enemy_field: HBoxContainer = $Board/EnemyField
@onready var drag_layer: Control = $DragLayer
@onready var mana_label: Label = $ManaLabel

const CARD_SCENE = preload("res://scenes/card.tscn")
const HAND_SIZE = 5

var hand_cards: Array[Card] = []

const ARC_RADIUS = 1500.0
const MAX_SPREAD_DEGREES = 28.0

func _ready() -> void:
	PlayerState.mana_changed.connect(_on_mana_changed)
	_update_mana_display(PlayerState.current_mana, PlayerState.max_mana)
	_draw_starting_hand()

func _draw_starting_hand() -> void:
	var available_cards = CardDatabase.all_cards.duplicate()
	available_cards.shuffle()
	for i in range(min(HAND_SIZE, available_cards.size())):
		_add_card_to_hand(available_cards[i])

func _add_card_to_hand(card_data: CardData) -> void:
	var card_instance = CARD_SCENE.instantiate()
	hand.add_child(card_instance)
	card_instance.setup(card_data)
	card_instance.drag_started.connect(_on_card_drag_started)
	card_instance.drag_ended.connect(_on_card_drag_ended)
	hand_cards.append(card_instance)
	_arrange_hand()

func _arrange_hand() -> void:
	var count = hand_cards.size()
	if count == 0:
		return

	var pivot = Vector2(hand.size.x / 2.0, hand.size.y + ARC_RADIUS)

	for i in range(count):
		var card = hand_cards[i]
		card.pivot_offset = card.size / 2.0
		var t = 0.0 if count == 1 else (float(i) / float(count - 1)) - 0.5
		var angle_degrees = t * MAX_SPREAD_DEGREES
		var angle_radians = deg_to_rad(angle_degrees)

		var target_position = pivot + Vector2(sin(angle_radians), -cos(angle_radians)) * ARC_RADIUS
		var target_rotation = angle_degrees

		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(card, "position", target_position - card.size / 2.0, 0.2)
		tween.tween_property(card, "rotation_degrees", target_rotation, 0.2)

func _on_card_drag_started(card: Card) -> void:
	var global_pos = card.global_position
	hand.remove_child(card)
	drag_layer.add_child(card)
	card.global_position = global_pos


func _on_card_drag_ended(card: Card, drop_position: Vector2) -> void:
	drag_layer.remove_child(card)

	var field_rect = player_field.get_global_rect()
	var card_cost = card.data.cost if card.data else 0

	if field_rect.has_point(drop_position) and PlayerState.current_mana >= card_cost:
		PlayerState.current_mana -= card_cost
		hand_cards.erase(card)
		player_field.add_child(card)
		card.rotation_degrees = 0
		_arrange_hand()
	else:
		hand.add_child(card)
		_arrange_hand()

func _on_mana_changed(current: int, max_mana: int) -> void:
	_update_mana_display(current, max_mana)

func _update_mana_display(current: int, max_mana: int) -> void:
	if mana_label:
		mana_label.text = "Mana: %d/%d" % [current, max_mana]

