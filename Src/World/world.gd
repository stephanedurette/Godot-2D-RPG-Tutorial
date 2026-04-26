extends Node2D

@export var player: Player
@export var startingLevel: Level
@export var levelParent: Node
@export var on_portal_entered_signal: SignalOneArg

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
	on_portal_entered_signal.connect_signal(on_portal_entered)
	
	unload_all_levels()
	
	load_level(startingLevel)
	player.global_position = startingLevel.defaultSpawnPosition.global_position
			
	
func on_portal_entered(p: Portal):
	if (is_player_teleporting):
		is_player_teleporting = false
		return
	
	is_player_teleporting = true
	
	var from : Level = p.level
	var to : Level = p.otherPortal.level
	
	if (from != to):
		load_level(to)
		unload_level(from)
	player.global_position = p.otherPortal.global_position
