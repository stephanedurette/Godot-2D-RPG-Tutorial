class_name Player

extends CharacterBody2D

@export_group("Settings")
@export var move_speed : float = 10

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
@export var sword: PlayerSword
@export var animation_tree: AnimationTree
@export var npc_raycast: RayCast2D
@export var inventory: Inventory
@export var health: Health

var npc_raycast_magnitude: float
var interactable_in_range: Node2D
var current_move_direction: Vector2

func _ready() -> void:
	_set_animation_blend_position(Vector2.DOWN)
	
	npc_raycast_magnitude = npc_raycast.target_position.length()
	
	on_item_collected.connect_signal(_on_item_collected)
	
	inventory.on_inventory_updated.connect(func(items): on_player_inventory_udpated.emit(items))
	
	health.on_health_changed.connect(func(h): on_health_changed.emit(h))
	health.on_health_depleted.connect(func(): on_health_depleted.emit())
	health.on_max_health_changed.connect(func(mh): on_max_health_changed.emit(mh))

func _process(_delta: float) -> void:
	velocity = current_move_direction * move_speed
	
	move_and_slide()
	_update_detected_npc()

func _on_player_input_on_move_direction_changed(direction: Vector2) -> void:
	current_move_direction = direction
	
	if (current_move_direction != Vector2.ZERO):
		print(current_move_direction)
		sword.look_at(sword.global_position + Vector2Utils.get_closest_cardinal_direction(current_move_direction))
		_set_animation_blend_position(current_move_direction)
		_update_raycast_direction(current_move_direction)
	
	animation_tree.set("parameters/conditions/idle", current_move_direction == Vector2.ZERO);
	animation_tree.set("parameters/conditions/moving", current_move_direction != Vector2.ZERO);

func _update_detected_npc():
	if (!npc_raycast.is_colliding()):
		interactable_in_range = null
		on_dialogue_end_request.emit()
		return
	
	interactable_in_range = npc_raycast.get_collider() as Node2D

func _update_raycast_direction(dir: Vector2):
	npc_raycast.target_position = dir * npc_raycast_magnitude
	

func _set_animation_blend_position(pos: Vector2):
	animation_tree.set("parameters/Idle/blend_position", pos)
	animation_tree.set("parameters/Move/blend_position", pos)

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
	sword.attack()


func _on_player_sword_attack_finished() -> void:
	pass # Replace with function body.


func _on_player_sword_attack_started() -> void:
	pass # Replace with function body.
