class_name Player

extends CharacterBody2D

@export var move_speed : float = 10

@onready var animation_tree: AnimationTree = $"AnimationTree"

var current_move_direction: Vector2

func _ready() -> void:
	animation_tree.set("parameters/Idle/blend_position", Vector2.DOWN)

func _process(_delta: float) -> void:
	velocity = current_move_direction * move_speed
	
	move_and_slide()

func _on_player_input_on_move_direction_changed(direction: Vector2) -> void:
	current_move_direction = direction
	
	if (current_move_direction != Vector2.ZERO):
		animation_tree.set("parameters/Idle/blend_position", current_move_direction)
		animation_tree.set("parameters/Move/blend_position", current_move_direction)
	
	animation_tree.set("parameters/conditions/idle", current_move_direction == Vector2.ZERO);
	animation_tree.set("parameters/conditions/moving", current_move_direction != Vector2.ZERO);
