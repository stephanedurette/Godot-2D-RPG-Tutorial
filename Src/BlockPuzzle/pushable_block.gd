class_name PushableBlock

extends RigidBody2D

@export var push_distance: int
@export var push_speed: float

@onready var rays: Array[ShapeCast2D] = [$Up, $Down, $Left, $Right]

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
		
		if ray.is_colliding() && ray.get_collider(0) is BlockPusher:
			if (-ray.target_position.dot((ray.get_collider(0) as BlockPusher).push_direction) > 0):
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
		pushable_block.state_machine.change_state(pushable_block.idle_state)
		
		
		
		
