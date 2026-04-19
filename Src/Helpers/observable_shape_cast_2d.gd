class_name ObservableShapeCast2D

extends ShapeCast2D

@export var groups_to_collide: Array[String]

func colliding() -> bool:
	for i in get_collision_count():
		if _is_node_valid(get_collider(i)):
			return true
	return false
	
func first() -> Node2D:
	for i in get_collision_count():
		if _is_node_valid(get_collider(i)):
			return get_collider(i)
	return null

func get_nearest(pos: Vector2) -> Node2D:
	var closest_sqr_dist: float = 1000
	var closest_node: Node2D
	for i in get_collision_count():
		var node: Node2D = get_collider(i) as Node2D
		
		if(!_is_node_valid(node)):
			continue
		
		var distance: float = node.global_position.distance_squared_to(pos)
		if(distance < closest_sqr_dist):
			closest_sqr_dist = distance
			closest_node = node
			
	return closest_node
		
func _is_node_valid(n: Node2D) -> bool:
	if (groups_to_collide.size() == 0):
		return true
	
	for g in groups_to_collide:
		if n.is_in_group(g):
			return true
	return false
