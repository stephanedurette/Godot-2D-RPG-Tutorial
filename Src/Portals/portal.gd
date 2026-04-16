class_name Portal

extends Area2D

@export var otherPortal: Portal
@export var level: Level

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		print("en")
		EventBus.on_portal_entered.emit(self)
	else:
		pass

func _on_body_exited(_body: Node2D) -> void:
	pass # Replace with function body.
