extends Control
const CARD_SCENE = preload("res://scenes/card.tscn")
const DECK_STATE = preload("res://scripts/deck_state.gd")
var player = DECK_STATE.new()
var enemy = DECK_STATE.new()
var hand_cards: Array[Card] = []
var field_cards: Array[Card] = []
var player_field: Control
var hand: Control
var enemy_hand: Control
var drag_layer: Control
var piles: Dictionary = {}
var mana_label: Label
var turn_label: Label
var end_turn_button: Button

func _ready() -> void:
	_build_table()
	PlayerState.mana_changed.connect(_update_mana_display)
	PlayerState.turn_changed.connect(_update_turn_display)
	player.setup(CardDatabase.all_cards)
	enemy.setup(CardDatabase.all_cards)
	for data in player.hand:
		_add_card_to_hand(data)
	resized.connect(_arrange_cards)
	_update_mana_display(PlayerState.current_mana, PlayerState.max_mana)
	_update_turn_display(PlayerState.current_turn)
	_update_piles()
	call_deferred("_arrange_cards")

func _area(title: String, rect: Rect2) -> Control:
	var panel := Panel.new()
	add_child(panel)
	panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	panel.anchor_left = rect.position.x
	panel.anchor_top = rect.position.y
	panel.anchor_right = rect.end.x
	panel.anchor_bottom = rect.end.y
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var label := Label.new()
	panel.add_child(label)
	label.text = title
	label.position = Vector2(8, 5)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return panel

func _pile(rect: Rect2) -> Label:
	var area := _area("", rect)
	var label := Label.new()
	area.add_child(label)
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return label

func _build_table() -> void:
	enemy_hand = _area("Mão do oponente", Rect2(0.18, 0.02, 0.64, 0.14))
	_area("Campo do oponente", Rect2(0.18, 0.18, 0.64, 0.25))
	player_field = _area("Seu campo", Rect2(0.18, 0.48, 0.64, 0.25))
	hand = _area("Sua mão — máximo 7", Rect2(0.18, 0.76, 0.64, 0.23))
	piles.enemy_deck = _pile(Rect2(0.02, 0.18, 0.14, 0.25))
	piles.enemy_graveyard = _pile(Rect2(0.84, 0.18, 0.14, 0.25))
	piles.player_graveyard = _pile(Rect2(0.02, 0.48, 0.14, 0.25))
	piles.player_deck = _pile(Rect2(0.84, 0.48, 0.14, 0.25))
	mana_label = _pile(Rect2(0.02, 0.76, 0.14, 0.11))
	turn_label = _pile(Rect2(0.18, 0.435, 0.64, 0.04))
	end_turn_button = Button.new()
	add_child(end_turn_button)
	end_turn_button.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	end_turn_button.anchor_left = 0.84
	end_turn_button.anchor_top = 0.8
	end_turn_button.anchor_right = 0.98
	end_turn_button.anchor_bottom = 0.92
	end_turn_button.text = "Finalizar turno"
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	drag_layer = Control.new()
	add_child(drag_layer)
	drag_layer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	drag_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _add_card_to_hand(data: CardData) -> void:
	var card: Card = CARD_SCENE.instantiate()
	hand.add_child(card)
	card.setup(data)
	card.drag_started.connect(_on_card_drag_started)
	card.drag_ended.connect(_on_card_drag_ended)
	hand_cards.append(card)

func _arrange_row(cards: Array[Card], area: Control) -> void:
	if cards.is_empty():
		return
	var card_scale := maxf(minf((area.size.y - 32) / 468.0, 0.5), 0.05)
	var width := 336.0 * card_scale
	var step := minf(width + 8, (area.size.x - width - 16) / maxf(cards.size() - 1, 1))
	var total := width + step * (cards.size() - 1)
	for i in range(cards.size()):
		var card := cards[i]
		if card.dragging:
			continue
		card.scale = Vector2.ONE * card_scale
		card.rotation = 0
		card.position = Vector2((area.size.x - total) / 2 + step * i, 28)

func _arrange_cards() -> void:
	_arrange_row(hand_cards, hand)
	_arrange_row(field_cards, player_field)
	for child in enemy_hand.get_children():
		if child is Card:
			child.free()
	var backs: Array[Card] = []
	for i in range(enemy.hand.size()):
		var card: Card = CARD_SCENE.instantiate()
		enemy_hand.add_child(card)
		card.set_face_down(true)
		backs.append(card)
	_arrange_row(backs, enemy_hand)

func _on_card_drag_started(card: Card) -> void:
	var global_pos := card.global_position
	card.reparent(drag_layer)
	card.global_position = global_pos

func _on_card_drag_ended(card: Card, drop_position: Vector2) -> void:
	var cost := card.data.cost if card.data else 0
	if PlayerState.can_player_act and player_field.get_global_rect().has_point(drop_position) and PlayerState.current_mana >= cost:
		PlayerState.current_mana -= cost
		player.hand.erase(card.data)
		hand_cards.erase(card)
		field_cards.append(card)
		card.reparent(player_field)
		card.can_drag = false
		card.set_face_down(false)
	else:
		card.reparent(hand)
	_arrange_cards()
	_update_piles()

func _update_piles() -> void:
	piles.player_deck.text = "DECK\nVerso\n%d cartas" % player.deck.size()
	piles.enemy_deck.text = "DECK\nVerso\n%d cartas" % enemy.deck.size()
	piles.player_graveyard.text = "CEMITÉRIO\n%d cartas" % player.graveyard.size()
	piles.enemy_graveyard.text = "CEMITÉRIO\n%d cartas" % enemy.graveyard.size()

func _update_mana_display(current: int, maximum: int) -> void:
	mana_label.text = "Mana: %d/%d" % [current, maximum]

func _update_turn_display(owner: PlayerState.TurnOwner) -> void:
	var active := owner == PlayerState.TurnOwner.PLAYER
	turn_label.text = "Seu turno" if active else "Turno do oponente"
	end_turn_button.disabled = not active

func _on_end_turn_pressed() -> void:
	if not PlayerState.can_player_act:
		return
	PlayerState.set_turn(PlayerState.TurnOwner.ENEMY)
	enemy.draw(2)
	_update_piles()
	_arrange_cards()
	await get_tree().create_timer(1.5).timeout
	start_player_turn()

func start_player_turn() -> void:
	PlayerState.reset_mana()
	for data in player.draw(2):
		_add_card_to_hand(data)
	PlayerState.set_turn(PlayerState.TurnOwner.PLAYER)
	_update_piles()
	_arrange_cards()
