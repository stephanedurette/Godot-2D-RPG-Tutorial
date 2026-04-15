extends Node

var currentPortalPath: String

func travel_to_portal(scene: String, portalPath: String):
	currentPortalPath = portalPath
	get_tree().change_scene_to_file.call_deferred(scene)
	
