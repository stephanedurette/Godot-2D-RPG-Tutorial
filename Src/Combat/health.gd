class_name Health

extends Node

signal on_value_changed(new_value: float)
signal on_damage_taken(damage: float)
signal on_healed(heal_amount: float)
signal on_value_depleted

@export var starting_value: float
@export var max_value: float

var health: float

func heal(amount: float):
	_add_health(amount)
	
func take_damage(amount: float):
	_add_health(-amount)

func _add_health(amount: float):
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
