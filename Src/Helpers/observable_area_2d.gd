class_name ObservableArea2D

extends Area2D

@export var filter_groups: Array[String]

signal on_node_entered(Node2D)
signal on_node_exited(Node2D)

@onready var box_collider: RectangleShape2D = $CollisionShape2D.shape

var _colliding_objects_hash_set: Dictionary[Node2D, bool]

func is_colliding() -> bool:
	return _colliding_objects_hash_set.size() > 0

func get_first() -> Node2D:
	return _colliding_objects_hash_set.keys()[0]

func set_size(size: Vector2):
	box_collider.size = size

func get_nearest(from_position: Vector3) -> Node2D:
	var smallest_distance: float = 1000
	var closest_node: Node2D
	
	for n in _colliding_objects_hash_set.keys():
		var distance: float = (from_position - n.global_position).length_squared()
		if (distance < smallest_distance):
			smallest_distance = distance
			closest_node = n
	
	return closest_node
	
func _on_entered(node: Node2D):
	if (_is_node_valid(node)):
		_colliding_objects_hash_set.get_or_add(node, true)
		on_node_entered.emit(node)

func _on_exited(node: Node2D):
	if (_is_node_valid(node)):
		_colliding_objects_hash_set.erase(node)
		on_node_exited.emit(node)

func _is_node_valid(node: Node2D) -> bool:
	if filter_groups.size() == 0:
		return true
		
	for f in filter_groups:
		if node.is_in_group(f):
			return true
	
	return false

func _on_area_entered(area: Area2D) -> void:
	_on_entered(area)


func _on_area_exited(area: Area2D) -> void:
	_on_exited(area)


func _on_body_entered(body: Node2D) -> void:
	_on_entered(body)


func _on_body_exited(body: Node2D) -> void:
	_on_exited(body)
