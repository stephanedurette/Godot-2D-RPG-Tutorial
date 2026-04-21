class_name Player

extends CharacterBody2D

@export var move_speed : float = 10

@onready var animation_tree: AnimationTree = $"AnimationTree"
@onready var npc_raycast: RayCast2D = $"NpcDetection"

var npc_raycast_magnitude: float
var detected_npc_in_range: NPC
var current_move_direction: Vector2

func _ready() -> void:
	_set_animation_blend_position(Vector2.DOWN)
	npc_raycast_magnitude = npc_raycast.target_position.length()

func _process(_delta: float) -> void:
	velocity = current_move_direction * move_speed
	
	move_and_slide()
	_update_detected_npc()

func _on_player_input_on_move_direction_changed(direction: Vector2) -> void:
	current_move_direction = direction
	
	if (current_move_direction != Vector2.ZERO):
		_set_animation_blend_position(current_move_direction)
		_update_raycast_direction(current_move_direction)
	
	animation_tree.set("parameters/conditions/idle", current_move_direction == Vector2.ZERO);
	animation_tree.set("parameters/conditions/moving", current_move_direction != Vector2.ZERO);

func _update_detected_npc():
	if (!npc_raycast.is_colliding()):
		detected_npc_in_range = null
		DialogueEvents.on_dialogue_end_request.emit()
		return
	
	detected_npc_in_range = npc_raycast.get_collider() as NPC

func _update_raycast_direction(dir: Vector2):
	npc_raycast.target_position = dir * npc_raycast_magnitude
	

func _set_animation_blend_position(pos: Vector2):
	animation_tree.set("parameters/Idle/blend_position", pos)
	animation_tree.set("parameters/Move/blend_position", pos)

func _on_interact_input_on_pressed() -> void:
	if (detected_npc_in_range == null):
		return
	
	DialogueEvents.on_npc_interacted.emit(detected_npc_in_range)


func _on_update_position_timer_timeout() -> void:
	WorldEvents.on_player_position_updated.emit(global_position)
