extends Node

signal mana_changed(current: int, max_mana: int)

@export var max_mana: int = 3:
	set(value):
		max_mana = max(0, value)
		current_mana = min(current_mana, max_mana)
		mana_changed.emit(current_mana, max_mana)

var current_mana: int = 3:
	set(value):
		current_mana = clamp(value, 0, max_mana)
		mana_changed.emit(current_mana, max_mana)

func _ready() -> void:
	current_mana = max_mana
