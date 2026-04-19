class_name PushableBlock

extends AnimatableBody2D

@export var push_distance: int
@export var push_speed: float
@export var first_push_time: float

@onready var player_colliders: Array[ObservableArea2D] = [$PlayerDetectors/Bottom, $PlayerDetectors/Top, $PlayerDetectors/Left, $PlayerDetectors/Right]
@onready var directions: Array[Vector2] = [Vector2.DOWN, Vector2.UP, Vector2.LEFT, Vector2.RIGHT]

var state_machine: State_Machine
var idle_state: IdleState
var pushing_state: PushingState

var player: Player
var player_direction: Vector2

@onready var obstacle_colliders: Dictionary[Vector2, ObservableArea2D] = {
	Vector2.UP: $ObstacleDetectors/Top,
	Vector2.DOWN: $ObstacleDetectors/Bottom,
	Vector2.LEFT: $ObstacleDetectors/Left,
	Vector2.RIGHT: $ObstacleDetectors/Right
}

func _ready() -> void:
	_initialize_state_machine()
	_initialize_player_colliders()
	_initialize_obstacle_colliders()

func _initialize_player_colliders():
	for i in player_colliders.size():
		player_colliders[i].connect("on_node_entered",func(node, _area): _on_player_entered_area(node, directions[i]))
		player_colliders[i].connect("on_node_exited", func(node, _area): _on_player_exited_area())
	
func _initialize_obstacle_colliders():
	for k in obstacle_colliders.keys():
		var size: Vector2 = Vector2(1 if k.x == 0 else push_distance, 1 if k.y == 0 else push_distance)
		var offset: Vector2 = Vector2(k.x * push_distance / 2, k.y * push_distance / 2)
		obstacle_colliders[k].set_size(size)
		obstacle_colliders[k].set_offset(offset)

func _initialize_state_machine():
	idle_state = IdleState.new(self)
	pushing_state = PushingState.new(self)
	
	state_machine = State_Machine.new()
	state_machine.change_state(idle_state)

func _process(delta: float) -> void:
	state_machine.current_state.process(delta)

func move_distance(dir: Vector2) -> int:
	if (dir == Vector2.ZERO):
		return 0
	
	if(!obstacle_colliders[dir].is_colliding()):
		return push_distance
	
	var closest: Node2D = obstacle_colliders[dir].get_nearest(global_position)
	print(closest.global_position.distance_to(global_position))
	
	return 0
	

func get_push_direction() -> Vector2:
	if (player == null):
		return Vector2.ZERO
	
	if player.current_move_direction.dot(-player_direction) > 0:
		return -player_direction
	
	return Vector2.ZERO

func _on_player_entered_area(node: Node2D, dir: Vector2):
	player = node as Player
	player_direction = dir
	
func _on_player_exited_area():
	player = null

class PushBlockState extends State:
	var pushable_block: PushableBlock
	
	func _init(p: PushableBlock) -> void:
		pushable_block = p

class IdleState extends PushBlockState:
	var current_push_time: float
	var current_push_direction: Vector2
	var current_move_distance: int
	
	func enter():
		pass
	
	func process(delta):
		var new_push_direction = pushable_block.get_push_direction()
		current_move_distance = pushable_block.move_distance(new_push_direction)
		
		if (new_push_direction == Vector2.ZERO || current_move_distance == 0):
			current_push_time = 0
			return
		
		if(new_push_direction != current_push_direction):
			current_push_direction = new_push_direction
			current_push_time = 0
			return
		
		current_push_time += delta
		if (current_push_time >= pushable_block.first_push_time):
			_on_push_finished()
		
	func _on_push_finished():
		pushable_block.pushing_state.target_position = pushable_block.global_position + current_push_direction * current_move_distance
		pushable_block.state_machine.change_state(pushable_block.pushing_state)

class PushingState extends PushBlockState:
	var target_position: Vector2
	
	func enter():
		var tween = pushable_block.get_tree().create_tween()
		tween.tween_property(pushable_block, "global_position", target_position, pushable_block.push_distance / pushable_block.push_speed)
		tween.tween_callback(on_push_finished)
	
	func process(_delta):
		pass
		
	func exit():
		pass
	
	func on_push_finished():
		pushable_block.idle_state.current_push_time = pushable_block.first_push_time
		
		pushable_block.global_position = target_position
		pushable_block.state_machine.change_state(pushable_block.idle_state)
		
		
		
		
		
