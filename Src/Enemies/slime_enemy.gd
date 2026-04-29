class_name SlimeEnemy extends CharacterBody2D

@export_group("Settings")
@export var move_speed:=2.0
@export var move_accel:=2.0
@export var min_patrol_time: float
@export var max_patrol_time: float
@export var player_detect_distance: float
@export var knockback_speed: float

@export_group("References")
@export var player_detector: Area2D
@export var player_detect_collision_shape: CollisionShape2D
@export var navigation_agent: NavigationAgent2D
@export var navigation_timer: Timer
@export var animation_tree: AnimationTree
@export var hit_flasher: HitFlasher

var idle_state: IdleState
var chasing_state: ChasingState
var state_machine: State_Machine

var move_velocity: Observable

func _ready() -> void:
	move_velocity = Observable.new(Vector2.ZERO)
	move_velocity.on_changed.connect(_on_move_velocity_changed)
	_ready_player_detector()
	_ready_state_machine()

func _on_move_velocity_changed(target_velocity: Vector2):
	animation_tree.set("parameters/moving/blend_position", target_velocity.normalized())

func _physics_process(delta: float) -> void:
	state_machine.current_state.process(delta)

func _on_health_on_health_changed(new_value: int) -> void:
	print(new_value)

func _on_health_on_health_depleted() -> void:
	print("dead")

func _on_player_detector_body_entered(body: Node2D) -> void:
	(state_machine.current_state as SlimeState).on_player_detected(body as Player)
	
func _ready_player_detector():
	player_detector.set_deferred("monitoring", false)
	await get_tree().process_frame #wait for the set_deferred to finish
	(player_detect_collision_shape.shape as CircleShape2D).radius = player_detect_distance
	player_detector.set_deferred("monitoring", true)
	
func _ready_state_machine():
	state_machine = State_Machine.new()
	idle_state = IdleState.new(self)
	chasing_state = ChasingState.new(self)
	state_machine.change_state(idle_state)
	
func _on_navigation_target_refresh_timer_timeout() -> void:
	(state_machine.current_state as SlimeState).on_navigation_timer_timeout()

func _on_hurtbox_hit(hitbox: Hitbox) -> void:
	velocity = (global_position - hitbox.global_position).normalized() * knockback_speed
	hit_flasher.flash()
	
class SlimeState extends State:
	var my_owner: SlimeEnemy
	
	func _init(_my_owner: SlimeEnemy) -> void:
		self.my_owner = _my_owner
	
	func on_player_detected(_body: Player):
		pass
		
	func on_navigation_timer_timeout():
		pass

class IdleState extends SlimeState:
	
	func enter():
		my_owner.animation_tree.set("parameters/conditions/idle", true);
	
	func exit():
		my_owner.animation_tree.set("parameters/conditions/idle", false);
	
	func on_player_detected(body: Player):
		my_owner.chasing_state.chase_target = body
		body.on_health_depleted.connect_signal(func(): my_owner.state_machine.change_state(my_owner.idle_state))
		my_owner.state_machine.change_state(my_owner.chasing_state)
	
	func process(_delta):
		my_owner.velocity = my_owner.velocity.move_toward(Vector2.ZERO, my_owner.move_accel)
		my_owner.move_and_slide()
	
class ChasingState extends SlimeState:
	var chase_target: Node2D
	var navigation_agent: NavigationAgent2D
	
	func _init(_my_owner: SlimeEnemy) -> void:
		super._init(_my_owner)
		navigation_agent = _my_owner.navigation_agent
		
	
	func enter():
		my_owner.animation_tree.set("parameters/conditions/moving", true);
		navigation_agent.target_position = chase_target.global_position
		print(navigation_agent.get_next_path_position())
		my_owner.navigation_timer.start()
		
	func exit():
		my_owner.animation_tree.set("parameters/conditions/moving", false);
		
		
	func process(_delta):
		if (!_at_target()):
			var dir = my_owner.global_position.direction_to(navigation_agent.get_next_path_position())
			my_owner.move_velocity.Value = dir * my_owner.move_speed
		else:
			my_owner.move_velocity.Value = Vector2.ZERO
			
		my_owner.velocity = my_owner.velocity.move_toward(my_owner.move_velocity.Value, my_owner.move_accel)
		my_owner.move_and_slide()
			
	func on_navigation_timer_timeout():
		if(!_at_target()):
			navigation_agent.target_position = chase_target.global_position
		my_owner.navigation_timer.start()
	
	func _at_target() -> bool: 
		return my_owner.global_position.distance_squared_to(chase_target.global_position) < 1
		
