extends Node

enum TurnOwner {
	PLAYER,
	ENEMY
}

signal mana_changed(current: int, max_mana: int)
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
