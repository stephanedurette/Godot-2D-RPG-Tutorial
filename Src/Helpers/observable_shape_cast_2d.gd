class_name ObservableShapeCast2D

extends ShapeCast2D

@export var groups_to_collide: Array[String]

func get_nearest_collision_distance() -> float:
	clear_exceptions()
	
	while(get_collision_count() > 0):
		if (_is_node_valid(get_collider(0))):
			return global_position.distance_to(get_collision_point(0))
		else:
			add_exception(get_collider(0))
			force_shapecast_update()
			
	return INF
		
func _is_node_valid(n: Node2D) -> bool:
	if (groups_to_collide.size() == 0):
		return true
	
	for g in groups_to_collide:
		if n.is_in_group(g):
			return true
	return false
