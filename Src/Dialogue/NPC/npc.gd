class_name NPC

extends StaticBody2D

@onready var animation_tree: AnimationTree = $AnimationTree

@export var player_react_distance: float
@export var dialogue_data: DialogueLineData

@export_group("Subscribed")
@export var on_player_position_updated: SignalOneArg

@export_group("Events")
@export var on_npc_interacted: SignalOneArg

func _ready() -> void:
	on_player_position_updated.connect_signal(_on_player_position_updated)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_player_position_updated(player_position: Vector2):
	var distance_vector = player_position - global_position
	
	if (player_react_distance**2 > distance_vector.length_squared()):
		animation_tree.set("parameters/Idle/blend_position", Vector2Utils.get_closest_cardinal_direction(distance_vector))
	else:
		animation_tree.set("parameters/Idle/blend_position", Vector2.DOWN)

func interact():
	on_npc_interacted.emit(self)
		
	
