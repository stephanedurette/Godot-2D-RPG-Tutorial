extends Node2D

@export var defaultSpawnPosition: Marker2D
@export var player: PackedScene
@export var level_camera: Camera2D

func _ready() -> void:
	print("loaded")
	if(PortalManager.currentPortalPath == ""):
		spawn_player(defaultSpawnPosition)
	else:
		spawn_player(get_node(PortalManager.currentPortalPath))
		
func spawn_player(positionNode: Node2D):
	var player_instance = player.instantiate() as Player
	positionNode.add_sibling(player_instance)
	player_instance.global_position = positionNode.global_position
	level_camera.reparent(player_instance, false)
		
