extends CharacterBody2D

@export var move_speed : float = 10

var current_move_direction: Vector2

func _process(delta: float) -> void:
	velocity = current_move_direction * move_speed
	move_and_slide()

func _on_player_input_on_move_direction_changed(direction: Vector2) -> void:
	current_move_direction = direction
