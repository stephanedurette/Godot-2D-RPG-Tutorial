extends CanvasLayer

@export var heart_container_ui: PackedScene

@export_group("Events")
@export var on_health_changed: SignalOneArg
@export var on_max_health_changed: SignalOneArg

@onready var heart_container_parent = $MarginContainer/HBoxContainer

func _ready() -> void:
	on_health_changed.connect_signal(_on_player_health_changed)
	on_max_health_changed.connect_signal(_on_player_max_health_changed)
	
func _on_player_health_changed(h: int):
	for i in heart_container_parent.get_child_count():
		(heart_container_parent.get_child(i) as HeartContainerUI).set_value(h - 4 * i)
	
func _on_player_max_health_changed(mh: int):
	var hearts_to_spawn = ceil((mh - heart_container_parent.get_child_count() * 4) / 4.0)
	for h in hearts_to_spawn:
		var inst = heart_container_ui.instantiate()
		heart_container_parent.add_child(inst)
		
