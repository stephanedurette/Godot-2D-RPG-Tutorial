class_name PlayerAnimations

extends AnimationTree

var velocity: Vector2

func _ready() -> void:
	set("parameters/Idle/blend_position", Vector2.DOWN)

func update_velocity(new_velocity: Vector2):
	velocity = new_velocity
	
	if (velocity != Vector2.ZERO):
		set("parameters/Idle/blend_position", velocity)
		set("parameters/Move/blend_position", velocity)
		get("parameters/playback").travel("Move")

	if (velocity == Vector2.ZERO):
		get("parameters/playback").travel("Idle")
		

	
