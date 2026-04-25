class_name Health

extends Node

signal on_health_changed(new_value: int)
signal on_max_health_changed(new_value: int)
signal on_health_depleted

@export var starting_max_health: int

var health: ClampedInt

func _ready() -> void:
	health = ClampedInt.new(starting_max_health, 0, starting_max_health)
	
	health.value.on_changed.connect(_on_health_changed)
	health.max_value.on_changed.connect(func(mh): on_max_health_changed.emit(mh))
	
	await get_tree().process_frame #call signals when all ready functions have been executed
	health.value.notify()
	health.max_value.notify()
	
func heal(amount: int):
	health.Value += amount
	
func take_damage(amount: int):
	health.Value -= amount

func _on_health_changed(amount: int):
	on_health_changed.emit(amount)
	if (amount <= 0):
		on_health_depleted.emit()
