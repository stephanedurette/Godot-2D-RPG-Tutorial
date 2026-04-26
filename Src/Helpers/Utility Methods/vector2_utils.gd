class_name Vector2Utils

static func get_closest_cardinal_direction(input_vector: Vector2) -> Vector2:
	var highest_dot: float = -INF
	var closest_direction: Vector2
	
	for cd in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		var distance_vector_dot = input_vector.dot(cd)
		if (distance_vector_dot > highest_dot):
			highest_dot = distance_vector_dot
			closest_direction = cd
			
	return closest_direction
