extends Node

@export var player_camera: PlayerCamera
@export var reset_objects: Array[Node2D]
@export var room_music: AudioStream

@export_group("Events")
@export var on_play_music_requested: SignalOneArg

func _ready() -> void:
	player_camera.on_player_entered.connect(_on_player_entered)
	player_camera.on_player_left.connect(_on_player_left)
	
func _on_player_entered():
	on_play_music_requested.emit(room_music)
	
func _on_player_left():
	for i in reset_objects:
		if i.has_method("reset"):
			i.call_deferred("reset")
