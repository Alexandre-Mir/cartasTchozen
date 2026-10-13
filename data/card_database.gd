extends Node

var all_cards: Array[CardData] = []
var cards_by_id: Dictionary = {}

func _ready() -> void:
	_load_all_cards()

func _load_all_cards() -> void:
	all_cards.clear()
	cards_by_id.clear()

	var dir = DirAccess.open("res://data/cards/")
	if not dir:
		push_error("Pasta de cartas não encontrada")
		return

	var file_names := Array(dir.get_files())
	file_names.sort()
	for file_name in file_names:
		if file_name.ends_with(".tres"):
			var card = load("res://data/cards/" + file_name) as CardData
			if card == null:
				push_error("Não foi possível carregar a carta: " + file_name)
				continue
			if not _is_card_valid(card, file_name):
				continue
			if cards_by_id.has(card.card_id):
				push_error("ID de carta duplicado '%s' em %s" % [card.card_id, file_name])
				continue
			all_cards.append(card)
			cards_by_id[card.card_id] = card

func _is_card_valid(card: CardData, file_name: String) -> bool:
	var valid := true
	if card.card_id.is_empty():
		push_error("Carta sem card_id: " + file_name)
		valid = false
	if card.card_name.strip_edges().is_empty():
		push_error("Carta sem nome: " + file_name)
		valid = false
	if card.cost < 0:
		push_error("Custo negativo na carta '%s': %s" % [card.card_name, file_name])
		valid = false
	if card.attack < 0 or card.health < 0:
		push_error("Atributo negativo na carta '%s': %s" % [card.card_name, file_name])
		valid = false
	return valid

func get_card_by_id(card_id: StringName) -> CardData:
	return cards_by_id.get(card_id) as CardData

func get_card_by_name(p_name: String) -> CardData:
	for card in all_cards:
		if card.card_name == p_name:
			return card
	return null
