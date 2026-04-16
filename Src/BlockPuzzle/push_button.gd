extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite

var colliding_bodies: Dictionary[Node2D,bool]

func _on_body_entered(body: Node2D) -> void:
	if (body is Player || body is PushableBlock):
		colliding_bodies.get_or_add(body, true)
		sprite.play("pressed")

func _on_body_exited(body: Node2D) -> void:
	if (body is Player || body is PushableBlock):
		colliding_bodies.erase(body)
		if colliding_bodies.size() == 0:
			sprite.play("unpressed")
