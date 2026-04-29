class_name Player

extends CharacterBody2D

@export_group("Settings")
@export var move_speed : float = 10
@export var move_accel: float
@export var knockback_speed: float

@export_group("Events")
@export var on_health_changed: SignalOneArg
@export var on_health_depleted: SignalNoArgs
@export var on_max_health_changed: SignalOneArg
@export var on_player_position_updated: SignalOneArg
@export var on_player_inventory_udpated: SignalOneArg
@export var on_dialogue_end_request: SignalNoArgs

@export_group("Subscribed")
@export var on_item_collected: SignalOneArg

@export_group("References")
@export var body_sprite: Sprite2D
@export var sword: PlayerSword
@export var animation_tree: AnimationTree
@export var npc_raycast: RayCast2D
@export var inventory: Inventory
@export var health: Health

var npc_raycast_magnitude: float
var interactable_in_range: Node2D
var current_move_direction: Vector2
var facing_direction: Vector2

var state_machine: State_Machine
var idle_state: IdleState
var walk_state: WalkingState
var attack_state: AttackState
var death_state: DeathState

func _ready() -> void:
	_ready_animation()
	_ready_interactor()
	_ready_inventory()
	_ready_health()
	_ready_state_machine()

func _ready_state_machine():
	idle_state = IdleState.new(self)
	walk_state = WalkingState.new(self)
	attack_state = AttackState.new(self)
	death_state = DeathState.new(self)
	state_machine = State_Machine.new()
	state_machine.change_state(idle_state)

func _ready_animation():
	current_move_direction = Vector2.DOWN

func _ready_inventory():
	on_item_collected.connect_signal(_on_item_collected)
	inventory.on_inventory_updated.connect(func(items): on_player_inventory_udpated.emit(items))

func _ready_health():
	health.on_health_changed.connect(func(h): on_health_changed.emit(h))
	health.on_health_depleted.connect(func(): on_health_depleted.emit())
	health.on_max_health_changed.connect(func(mh): on_max_health_changed.emit(mh))

func _ready_interactor():
	npc_raycast_magnitude = npc_raycast.target_position.length()

func _process(delta: float) -> void:
	state_machine.current_state.process(delta)

func _on_player_input_on_move_direction_changed(direction: Vector2) -> void:
	(state_machine.current_state as PlayerState).on_move_direction_changed(direction)

func _update_sword():
	var cardinal_direction = Vector2Utils.get_closest_cardinal_direction(facing_direction)
	sword.look_at(sword.global_position + cardinal_direction)
	
	move_child(sword, body_sprite.get_index() + (1 if cardinal_direction == Vector2.DOWN else -1))

func _update_detected_npc():
	if (!npc_raycast.is_colliding()):
		interactable_in_range = null
		on_dialogue_end_request.emit()
		return
	
	interactable_in_range = npc_raycast.get_collider() as Node2D

func _update_raycast_direction(dir: Vector2):
	npc_raycast.target_position = dir * npc_raycast_magnitude

func _on_interact_input_on_pressed() -> void:
	if (interactable_in_range == null):
		return
	
	if (interactable_in_range.has_method("interact")):
		interactable_in_range.interact()

func _on_update_position_timer_timeout() -> void:
	on_player_position_updated.emit(global_position)
	
func _on_item_collected(item: ItemData):
	inventory.add(item, 1)

func _on_attack_input_on_pressed() -> void:
	(state_machine.current_state as PlayerState).on_attack_input_pressed()

func _on_player_sword_attack_finished() -> void:
	(state_machine.current_state as PlayerState).on_attack_finished()

func _on_hurtbox_hit(hitbox: Hitbox) -> void:
	velocity = (global_position - hitbox.global_position).normalized() * knockback_speed
	
func _on_health_depleted() -> void:
	state_machine.change_state(death_state)
	
class PlayerState extends State:
	var player: Player
	
	func _init(p: Player) -> void:
		player = p
		
	func on_move_direction_changed(dir: Vector2):
		player.current_move_direction = dir
		if (dir != Vector2.ZERO):
			player.facing_direction = dir
			player.animation_tree.set("parameters/Idle/blend_position", dir)
	
	func on_attack_input_pressed():
		player.state_machine.change_state(player.attack_state)
		
	func on_attack_finished():
		pass
	
class IdleState extends PlayerState:
	func enter():
		player.animation_tree.set("parameters/conditions/idle", true);
		player.velocity = Vector2.ZERO
	
	func exit():
		player.animation_tree.set("parameters/conditions/idle", false);
		
	func process(_delta):
		player.velocity = player.velocity.move_toward(Vector2.ZERO, player.move_accel)
		player.move_and_slide()
	
	func on_move_direction_changed(dir: Vector2):
		super.on_move_direction_changed(dir)
		
		if (dir != Vector2.ZERO):
			player.state_machine.change_state(player.walk_state)
	
class DeathState extends PlayerState:
	func on_attack_input_pressed():
		pass
	
	func on_move_direction_changed(_dir: Vector2):
		pass
	
	func process(_delta):
		player.velocity = player.velocity.move_toward(Vector2.ZERO, player.move_accel)
		player.move_and_slide()
	
	func enter():
		player.animation_tree.set("parameters/conditions/idle", true);
		await player.get_tree().create_timer(.5).timeout
		player.animation_tree.get("parameters/playback").travel("death")
	
class WalkingState extends PlayerState:
	func enter():
		player._update_raycast_direction(player.current_move_direction)
		player.animation_tree.set("parameters/Move/blend_position", player.current_move_direction)
		player.animation_tree.set("parameters/conditions/moving", true);
	
	func exit():
		player.animation_tree.set("parameters/conditions/moving", false);
	
	func process(_delta):
		player.velocity = player.velocity.move_toward(player.current_move_direction * player.move_speed, player.move_accel)
		player.move_and_slide()
		player._update_detected_npc()
	
	func on_move_direction_changed(dir: Vector2):
		super.on_move_direction_changed(dir)
		
		if (dir == Vector2.ZERO):
			player.state_machine.change_state(player.idle_state)
		else:
			player.animation_tree.set("parameters/Move/blend_position", dir)
			player._update_raycast_direction(dir)
			player._update_sword()
					
class AttackState extends PlayerState:
	func enter():
		player.animation_tree.set("parameters/Attack/blend_position", player.facing_direction)
		player.animation_tree.set("parameters/conditions/attacking", true);
		player._update_sword()
		player.velocity = Vector2.ZERO
		player.sword.attack()
	
	func process(_delta):
		player.move_and_slide()
		
	func exit():
		player.animation_tree.set("parameters/conditions/attacking", false);
		
	func on_attack_input_pressed():
		pass
		
	func on_move_direction_changed(dir: Vector2):
		super.on_move_direction_changed(dir)
		
	func on_attack_finished():
		player.state_machine.change_state(player.idle_state as State if player.current_move_direction == Vector2.ZERO else player.walk_state as State)
