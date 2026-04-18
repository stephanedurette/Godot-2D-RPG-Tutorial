class_name PushableBlock

extends AnimatableBody2D

@export var push_distance: int
@export var push_speed: float
@export var first_push_time: float

@onready var player_detection: Dictionary[Vector2, ObservableShapeCast2D] = {
	Vector2.UP:$PlayerDetectors/Up,
	Vector2.DOWN:$PlayerDetectors/Down,
	Vector2.LEFT:$PlayerDetectors/Left,
	Vector2.RIGHT:$PlayerDetectors/Right,
}

var state_machine: State_Machine
var idle_state: IdleState
var pushing_state: PushingState

var space_state

func _ready() -> void:
	_initialize_state_machine()

func _initialize_state_machine():
	idle_state = IdleState.new(self)
	pushing_state = PushingState.new(self)
	
	state_machine = State_Machine.new()
	state_machine.change_state(idle_state)

func _process(delta: float) -> void:
	state_machine.current_state.process(delta)

func can_move(dir: Vector2) -> bool:
	return true
	#return res == null
	

func get_push_direction() -> Vector2:
	for direction in player_detection.keys():
		if !player_detection[direction].colliding():
			continue
			
		var p: Player = player_detection[direction].first() as Player
		if p.current_move_direction.dot(-direction) > 0:
			return -direction
				
	return Vector2.ZERO

class PushBlockState extends State:
	var pushable_block: PushableBlock
	
	func _init(p: PushableBlock) -> void:
		pushable_block = p

class IdleState extends PushBlockState:
	var current_push_time: float
	var current_push_direction: Vector2
	
	func enter():
		pass
	
	func process(delta):
		var new_push_direction = pushable_block.get_push_direction()
		if (new_push_direction == Vector2.ZERO):
			current_push_time = 0
			return
		
		if (!pushable_block.can_move(new_push_direction)):
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
		pushable_block.pushing_state.target_position = pushable_block.global_position + current_push_direction * pushable_block.push_distance
		pushable_block.state_machine.change_state(pushable_block.pushing_state)

class PushingState extends PushBlockState:
	var target_position: Vector2
	
	func enter():
		var tween = pushable_block.get_tree().create_tween()
		tween.tween_property(pushable_block, "global_position", target_position, pushable_block.push_distance / pushable_block.push_speed)
		tween.tween_callback(on_push_finished)
	
	func process(delta):
		pass
		
	func exit():
		pass
	
	func on_push_finished():
		pushable_block.idle_state.current_push_time = pushable_block.first_push_time
		
		pushable_block.state_machine.change_state(pushable_block.idle_state)
		pushable_block.global_position = target_position
		
		
		
		
