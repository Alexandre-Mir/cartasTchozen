extends Node

enum TurnOwner {
	PLAYER,
	ENEMY
}

signal mana_changed(current: int, max_mana: int)
signal life_changed(current: int, maximum: int)
signal opponent_resources_changed()
var opponent_max_life: int = 100
var opponent_life: int = 100:
	set(value):
		opponent_life = clampi(value, 0, opponent_max_life)
		opponent_resources_changed.emit()
var opponent_max_mana: int = 3
var opponent_mana: int = 3:
	set(value):
		opponent_mana = clampi(value, 0, opponent_max_mana)
		opponent_resources_changed.emit()

var max_life: int = 100:
	set(value):
		max_life = maxi(0, value)
		current_life = mini(current_life, max_life)
		life_changed.emit(current_life, max_life)
var current_life: int = 100:
	set(value):
		current_life = clampi(value, 0, max_life)
		life_changed.emit(current_life, max_life)
signal turn_changed(owner: TurnOwner)

@export var max_mana: int = 3:
	set(value):
		max_mana = max(0, value)
		current_mana = min(current_mana, max_mana)
		mana_changed.emit(current_mana, max_mana)

var current_mana: int = 3:
	set(value):
		current_mana = clamp(value, 0, max_mana)
		mana_changed.emit(current_mana, max_mana)

var current_turn: TurnOwner = TurnOwner.PLAYER:
	set(value):
		current_turn = value
		turn_changed.emit(current_turn)

var can_player_act: bool:
	get:
		return current_turn == TurnOwner.PLAYER

func _ready() -> void:
	current_mana = max_mana

func reset_mana() -> void:
	current_mana = max_mana

func set_turn(new_turn: TurnOwner) -> void:
	current_turn = new_turn
