class_name Health

extends Node

signal on_value_changed(new_value: int)
signal on_damage_taken(damage: int)
signal on_healed(heal_amount: int)
signal on_value_depleted

@export var max_value: int

var health: int

func _ready() -> void:
	health = max_value

func heal(amount: int):
	_add_health(amount)
	
func take_damage(amount: int):
	_add_health(-amount)

func _add_health(amount: int):
	var new_health = clamp(health + amount, 0, max_value)
	if (new_health == health):
		return
	if (new_health > health):
		on_healed.emit(new_health - health)
	if (new_health < health):
		on_damage_taken.emit(health - new_health)
	on_value_changed.emit(new_health)
	if (new_health <= 0):
		on_value_depleted.emit()
	health = new_health
