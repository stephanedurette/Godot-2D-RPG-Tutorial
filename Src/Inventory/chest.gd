class_name Chest

extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D= $"Sprite"

var open
var player_in_position

func _ready() -> void:
	pass
	
func interact():
	if (open || !player_in_position):
		return
		
	animated_sprite.play("open")
	open = true


func _on_player_area_body_entered(_body: Node2D) -> void:
	player_in_position = true


func _on_player_area_body_exited(_body: Node2D) -> void:
	player_in_position = false
