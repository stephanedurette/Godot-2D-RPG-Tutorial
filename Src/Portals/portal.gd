class_name Portal

extends Area2D

@export var otherPortal: Portal
@export var level: Level

@export var signal_bus: SignalOneArg

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		signal_bus.emit(self)
	else:
		pass

func _on_body_exited(_body: Node2D) -> void:
	pass # Replace with function body.
