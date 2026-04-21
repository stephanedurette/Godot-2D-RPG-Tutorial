class_name NPC

extends StaticBody2D

@onready var animation_tree: AnimationTree = $AnimationTree

@export var player_react_distance: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	WorldEvents.on_player_position_updated.connect(_on_player_position_updated)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_player_position_updated(player_position: Vector2):
	var distance_vector = player_position - global_position
	
	if (player_react_distance**2 > distance_vector.length_squared()):
		animation_tree.set("parameters/Idle/blend_position", _get_closest_cardinal_direction(distance_vector))
	else:
		animation_tree.set("parameters/Idle/blend_position", Vector2.DOWN)


func _get_closest_cardinal_direction(direction: Vector2) -> Vector2:
	var highest_dot: float = -INF
	var closest_direction: Vector2
	
	for cd in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		var distance_vector_dot = direction.dot(cd)
		if (distance_vector_dot > highest_dot):
			highest_dot = distance_vector_dot
			closest_direction = cd
			
	return closest_direction
		
	
