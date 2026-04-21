class_name FilteredRaycast2D

extends RayCast2D

@export var groups_to_collide: Array[String]

func get_filtered_collision() -> Dictionary:
	clear_exceptions()
	force_raycast_update()
	
	while(is_colliding()):
		if (_is_node_valid(get_collider())):
			return { "distance": global_position.distance_to(get_collision_point()), "collider": get_collider() }
		else:
			add_exception(get_collider())
			force_raycast_update()
			
	return {}
		
func _is_node_valid(n: Node2D) -> bool:
	if (groups_to_collide.size() == 0):
		return true
	
	for g in groups_to_collide:
		if n.is_in_group(g):
			return true
	return false
