extends RefCounted

var units: Dictionary = {}
var next_id := 1
var turns: Array[int] = [1, 0]
var active_owner := 0
var phase := "main"
var combat_done := false
var attacks: Array[Dictionary] = []
var blockers: Dictionary = {}

func play_card(data: CardData, owner: int) -> int:
	if data.is_spell():
		return -1
	var id := next_id
	next_id += 1
	units[id] = {"id": id, "data": data, "owner": owner, "entered": turns[owner], "used": false}
	return id

func start_turn(owner: int) -> void:
	active_owner = owner
	turns[owner] += 1
	phase = "main"
	combat_done = false
	attacks.clear()
	blockers.clear()
	for unit in units.values():
		if unit.owner == owner:
			unit.used = false

func can_attack(id: int) -> bool:
	if not units.has(id):
		return false
	var unit: Dictionary = units[id]
	return unit.owner == active_owner and unit.data.attack > 0 and not unit.used and unit.entered < turns[unit.owner]

func begin_attacks() -> bool:
	if phase != "main" or combat_done:
		return false
	phase = "attack"
	attacks.clear()
	blockers.clear()
	return true

func cancel_attacks() -> void:
	if phase == "attack":
		attacks.clear()
		phase = "main"

func declare_attack(attacker: int) -> bool:
	if phase != "attack" or not can_attack(attacker):
		return false
	remove_attack(attacker)
	attacks.append({"attacker": attacker, "target": -1})
	return true

func remove_attack(attacker: int) -> void:
	if phase != "attack":
		return
	for i in range(attacks.size() - 1, -1, -1):
		if attacks[i].attacker == attacker:
			attacks.remove_at(i)

func confirm_attacks() -> bool:
	if phase != "attack":
		return false
	phase = "defense"
	return true

func can_defend(id: int) -> bool:
	if phase != "defense" or not units.has(id) or units[id].owner == active_owner:
		return false
	return true

func assign_blocker(attacker: int, defender: int) -> bool:
	if not can_defend(defender):
		return false
	var declared := false
	for order in attacks:
		if order.attacker == attacker:
			declared = true
	if not declared:
		return false
	# Selecting a new assignment moves that defender, never duplicates it.
	for key in blockers.keys():
		if blockers[key] == defender:
			blockers.erase(key)
	blockers[attacker] = defender
	return true

func remove_blocker(defender: int) -> void:
	if phase != "defense":
		return
	for key in blockers.keys():
		if blockers[key] == defender:
			blockers.erase(key)

func resolve() -> Array[Dictionary]:
	var results: Array[Dictionary] = []
	if phase != "defense":
		return results
	var defeated: Dictionary = {}
	for order in attacks:
		if not can_attack(order.attacker):
			continue
		var attacker: Dictionary = units[order.attacker]
		var target: int = blockers.get(order.attacker, -1)
		var result := {"attacker": order.attacker, "target": target, "owner": active_owner, "damage": 0, "defeated": false}
		if target == -1:
			result.damage = attacker.data.attack
		elif units.has(target):
			result.defeated = attacker.data.attack > units[target].data.health
			if result.defeated:
				defeated[target] = units[target]
		attacker.used = true
		results.append(result)
	for id in defeated:
		units.erase(id)
	combat_done = true
	phase = "main"
	return results
