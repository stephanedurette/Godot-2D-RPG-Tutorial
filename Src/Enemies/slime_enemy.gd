extends CharacterBody2D

@export_group("Settings")
@export var move_speed:=2.0
@export var min_patrol_time: float
@export var max_patrol_time: float
@export var player_detect_distance: float

@export_group("References")
@export var player_detect_collision_shape: CollisionShape2D

func _ready() -> void:
	_ready_player_detector()

func _on_health_on_health_changed(new_value: int) -> void:
	print(new_value)

func _on_health_on_health_depleted() -> void:
	print("dead")

func _on_player_detector_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	
func _ready_player_detector():
	(player_detect_collision_shape.shape as CircleShape2D).radius = player_detect_distance
