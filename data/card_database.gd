extends Node

var all_cards: Array[CardData] = []

func _ready() -> void:
	_load_all_cards()

func _load_all_cards() -> void:
	var dir = DirAccess.open("res://data/cards/")
	if not dir:
		push_error("Pasta de cartas não encontrada")
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var card = load("res://data/cards/" + file_name) as CardData
			all_cards.append(card)
		file_name = dir.get_next()
	dir.list_dir_end()

func get_card_by_name(p_name: String) -> CardData:
	for card in all_cards:
		if card.card_name == p_name:
			return card
	return null
