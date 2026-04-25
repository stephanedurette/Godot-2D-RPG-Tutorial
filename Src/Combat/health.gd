class_name Health

extends Node

signal on_health_changed(new_value: int)
signal on_max_health_changed(new_value: int)
signal on_health_depleted

@export var starting_max_health: int

var health: Observable
var max_health: Observable

func _ready() -> void:
	health = Observable.new(starting_max_health)
	max_health = Observable.new(starting_max_health)
	
	health.on_changed.connect(_on_health_changed)
	max_health.on_changed.connect(func(mh): on_max_health_changed.emit(mh))
	
	await get_tree().process_frame #call signals when all ready functions have been executed
	health.notify()
	max_health.notify()
	
func heal(amount: int):
	health.Value = min(max_health.Value, health.Value + amount)
	
func take_damage(amount: int):
	health.Value = max(0, health.Value - amount)

func _on_health_changed(amount: int):
	on_health_changed.emit(amount)
	if (amount <= 0):
		on_health_depleted.emit()
