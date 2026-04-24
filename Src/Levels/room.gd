extends Node

@export var player_camera: PlayerCamera
@export var reset_objects: Array[Node2D]

func _ready() -> void:
	player_camera.on_player_left.connect(_on_player_left)
	
func _on_player_left():
	for i in reset_objects:
		if i.has_method("reset"):
			i.call_deferred("reset")
