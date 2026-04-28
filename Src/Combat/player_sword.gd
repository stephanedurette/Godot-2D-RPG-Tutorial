class_name PlayerSword extends Node2D

signal attack_started
signal attack_finished

@export_group("Settings")
@export var swing_time: float

@export_group("References")
@export var hitbox: Hitbox
@export var swing_pivot: Node2D

var is_attacking: ObservableBool

func _ready() -> void:
	is_attacking = ObservableBool.new(false)
	is_attacking.on_set_to_true.connect(_on_attacking_true)
	is_attacking.on_set_to_false.connect(_on_attacking_false)
	await get_tree().process_frame #call signals when all ready functions have been executed
	is_attacking.notify()

func attack():
	if (is_attacking.Value):
		return
	
	attack_started.emit()
	
	is_attacking.Value = true
	swing_pivot.rotation_degrees = 0
	
	var tween = get_tree().create_tween()
	tween.tween_property(swing_pivot, "rotation_degrees", 90, swing_time)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
			
	tween.tween_callback(func():
		is_attacking.Value = false 
		attack_finished.emit()
	)
		
func _on_attacking_true():
	hitbox.set_deferred("monitorable", true)
	swing_pivot.visible = true
	
func _on_attacking_false():
	hitbox.set_deferred("monitorable", false)
	swing_pivot.visible = false
