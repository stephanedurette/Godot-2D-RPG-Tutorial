extends CanvasLayer

@export_group("Events")
@export var on_health_changed: SignalOneArg
@export var on_max_health_changed: SignalOneArg

func _ready() -> void:
	on_health_changed.connect_signal(_on_player_health_changed)
	on_max_health_changed.connect_signal(_on_player_max_health_changed)
	
func _on_player_health_changed(h: int):
	print(h)
	
func _on_player_max_health_changed(mh: int):
	print(mh)
