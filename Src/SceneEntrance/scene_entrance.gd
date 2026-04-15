extends Area2D

@export var destinationScene: String

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		get_tree().change_scene_to_file.call_deferred(destinationScene)


func _on_body_exited(_body: Node2D) -> void:
	pass # Replace with function body.

#try this: https://www.youtube.com/watch?v=3AdAnxrZWGo 
