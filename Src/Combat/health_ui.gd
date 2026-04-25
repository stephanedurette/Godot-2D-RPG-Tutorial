extends CanvasLayer

func _ready() -> void:
	WorldEvents.on_player_health_changed.connect(_on_player_health_changed)
	WorldEvents.on_player_max_health_changed.connect(_on_player_max_health_changed)
	
func _on_player_health_changed(h: int):
	print(h)
	
func _on_player_max_health_changed(mh: int):
	print(mh)
