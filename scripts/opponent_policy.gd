extends RefCounted

# Evaluate complete affordable combinations, then play their first card.
# Stable hand order breaks ties, making the same state produce the same choice.
static func choose_card(hand: Array[CardData], mana: int) -> int:
	var selected := -1
	var best_cost := -1
	var best_stats := -1
	var best_count := -1
	for mask in range(1, 1 << hand.size()):
		var cost := 0
		var stats := 0
		var count := 0
		var first := -1
		for i in range(hand.size()):
			if mask & (1 << i):
				cost += maxi(0, hand[i].cost)
				stats += maxi(0, hand[i].attack) + maxi(0, hand[i].health)
				count += 1
				if first == -1:
					first = i
		if cost > mana:
			continue
		if cost > best_cost or (cost == best_cost and stats > best_stats) or (cost == best_cost and stats == best_stats and count > best_count):
			selected = first
			best_cost = cost
			best_stats = stats
			best_count = count
	return selected
