class_name PushableBlock

extends RigidBody2D

@export var push_distance: float
@export var push_speed: float

@onready var rays: Array[RayCast2D] = [$Up, $Down, $Left, $Right]

var state_machine: State_Machine
var idle_state: IdleState
var pushing_state: PushingState

func _ready() -> void:
	idle_state = IdleState.new(self)
	pushing_state = PushingState.new(self)
	
	state_machine = State_Machine.new()
	state_machine.change_state(idle_state)

func _process(delta: float) -> void:
	state_machine.current_state.process(delta)

func get_push_direction() -> Vector2:
	for ray in rays:
		var collider = ray.get_collider()
		if collider is BlockPusher:
			if (-ray.target_position.dot((collider as BlockPusher).push_direction) > 0):
				return -ray.target_position.normalized()
	return Vector2.ZERO

class PushBlockState extends State:
	var pushable_block: PushableBlock
	
	func _init(p: PushableBlock) -> void:
		pushable_block = p

class IdleState extends PushBlockState:
	func process(delta):
		var current_push_direction = pushable_block.get_push_direction()
		if (current_push_direction != Vector2.ZERO):
			pushable_block.state_machine.change_state(pushable_block.pushing_state)

class PushingState extends PushBlockState:
	func enter():
		pass
	
	func process(delta):
		pass
		
	func exit():
		pass
		
		
		
		
