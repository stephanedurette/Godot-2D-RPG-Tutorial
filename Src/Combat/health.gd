class_name Health

extends Node

signal on_health_changed(new_value: int)
signal on_max_health_changed(new_value: int)
signal on_damage_taken(damage: int)
signal on_healed(heal_amount: int)
signal on_health_depleted

@export var starting_max_health: int

var health: int
var max_health: int

func _ready() -> void:
	health = starting_max_health
	max_health = starting_max_health

func add_max_health(amount: int):
	max_health += amount
	on_max_health_changed.emit(max_health)

func heal(amount: int):
	_add_health(amount)
	
func take_damage(amount: int):
	_add_health(-amount)

func _add_health(amount: int):
	var new_health = clamp(health + amount, 0, max_health)
	if (new_health == health):
		return
	if (new_health > health):
		on_healed.emit(new_health - health)
	if (new_health < health):
		on_damage_taken.emit(health - new_health)
	on_health_changed.emit(new_health)
	if (new_health <= 0):
		on_health_depleted.emit()
	health = new_health
