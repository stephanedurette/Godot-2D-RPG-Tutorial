extends CharacterBody2D

@export var move_speed : float = 10

@export var animation_player: PlayerAnimations

var current_move_direction: Vector2

func _process(_delta: float) -> void:
	velocity = current_move_direction * move_speed
	
	animation_player.update_velocity(velocity)
	move_and_slide()

func _on_player_input_on_move_direction_changed(direction: Vector2) -> void:
	current_move_direction = direction
