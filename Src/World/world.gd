extends Node2D

@export var player: Player
@export var startingLevel: Level
@export var levelParent: Node

var is_player_teleporting: bool

func load_level(level: Level):
	levelParent.add_child.call_deferred(level)

func unload_level(level: Level):
	levelParent.remove_child.call_deferred(level)

func unload_all_levels():
	for l in levelParent.get_children():
		if (l is Level):
			unload_level(l)

func _ready() -> void:
	WorldEvents.on_portal_entered.connect(on_portal_entered)
	
	unload_all_levels()
	
	load_level(startingLevel)
	startingLevel.add_player(player, startingLevel.defaultSpawnPosition)
			
	
func on_portal_entered(p: Portal):
	if (is_player_teleporting):
		is_player_teleporting = false
		return
	
	is_player_teleporting = true
	
	var from : Level = p.level
	var to : Level = p.otherPortal.level
	
	if (from != to):
		load_level(to)
		from.remove_player()
		to.add_player(player, p.otherPortal)
		unload_level(from)
	else:
		player.global_position = p.otherPortal.global_position
