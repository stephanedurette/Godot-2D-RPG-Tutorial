class_name PushButton

extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite

signal pressed
signal unpressed

@export var stays_pressed: bool = false

var colliding_bodies = 0

func _on_body_entered(_body: Node2D) -> void:
		colliding_bodies +=1
		sprite.play("pressed")
		pressed.emit()

func _on_body_exited(_body: Node2D) -> void:
	if stays_pressed:
		return
	
	colliding_bodies -= 1
	if colliding_bodies == 0:
		sprite.play("unpressed")
		unpressed.emit()
