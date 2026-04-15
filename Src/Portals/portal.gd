extends Area2D

@export var destinationScene: String
@export var destinationPortalFullPath: String

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		if (PortalManager.currentPortalPath == ""):
			PortalManager.travel_to_portal(destinationScene, destinationPortalFullPath)
		else:
			PortalManager.currentPortalPath = ""


func _on_body_exited(_body: Node2D) -> void:
	pass # Replace with function body.

#try this: https://www.youtube.com/watch?v=3AdAnxrZWGo 
