extends Node2D

@export var player: Player
@export var startingLevel: Level
@export var levelParent: Node

var is_player_teleporting: bool

func _ready() -> void:
	EventBus.on_portal_entered.connect(on_portal_entered)
	
	for l in levelParent.get_children():
		if (l is Level):
			l.visible = true
			levelParent.remove_child(l)
	
	levelParent.add_child(startingLevel)
	startingLevel.add_player(player, startingLevel.defaultSpawnPosition)
			
	
func on_portal_entered(p: Portal):
	if (is_player_teleporting):
		is_player_teleporting = false
		return
	
	is_player_teleporting = true
	
	if (p.otherPortal.level != p.level):
		levelParent.add_child.call_deferred(p.otherPortal.level)
		
	p.level.remove_player()
	p.otherPortal.level.add_player(player, p.otherPortal)
	
	if (p.otherPortal.level != p.level):
		levelParent.remove_child.call_deferred(p.level)
