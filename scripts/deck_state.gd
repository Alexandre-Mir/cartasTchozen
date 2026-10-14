extends RefCounted
const DECK_SIZE := 60
const HAND_LIMIT := 7
var deck: Array[CardData] = []
var hand: Array[CardData] = []
var graveyard: Array[CardData] = []

func setup(available: Array[CardData], initial_hand_size: int = HAND_LIMIT) -> void:
	deck.clear()
	hand.clear()
	graveyard.clear()
	if available.is_empty():
		return
	for i in range(DECK_SIZE):
		deck.append(available[i % available.size()])
	deck.shuffle()
	draw(initial_hand_size)

func draw(amount: int = 2) -> Array[CardData]:
	var drawn: Array[CardData] = []
	for i in range(mini(amount, mini(HAND_LIMIT - hand.size(), deck.size()))):
		var card: CardData = deck.pop_back()
		hand.append(card)
		drawn.append(card)
	return drawn
