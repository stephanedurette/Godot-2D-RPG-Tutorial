class_name Level

extends Node2D

@export var defaultSpawnPosition: Marker2D
@export var level_camera: Camera2D
		
func add_player(p: Player, positionNode: Node2D):
	p.global_position = positionNode.global_position
	level_camera.owner = null
	level_camera.reparent(p, false)
		
func remove_player():
	level_camera.reparent(self, false)
