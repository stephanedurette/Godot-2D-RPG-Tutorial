extends Node2D

class_name Raycaster2D

var space_state: PhysicsDirectSpaceState2D
	
func physics_process(_delta):
	space_state = get_world_2d().direct_space_state
	
func ray(direction: Vector2, start_position: Vector2, length: float, filter_groups: Array[String]) -> Node2D:
	
	var query = PhysicsRayQueryParameters2D.create(start_position, start_position + length * direction)
	query.collision_mask = 0xFFFFFFFF #maybe not necessary
	
	var exclude_list = []
	while true:
		query.exclude = exclude_list
		var result: Dictionary = space_state.intersect_ray(query)
		if result.is_empty():
			return null
		 
		if _is_node_in_group_list(result["collider"], filter_groups):
			print(result["collider"])
			return result["collider"]
		else:
			exclude_list.append(result["rid"])
	return null
	
func _is_node_in_group_list(node: Node2D, groups: Array[String]) -> bool:
	if (groups.size() == 0):
		return true
	
	for g in groups:
		if node.is_in_group(g):
			return true
	return false
