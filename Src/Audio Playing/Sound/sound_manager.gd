extends Node

@export_group("References")
@export var sound_player_prefab: PackedScene

@export_group("Settings")
@export var preloaded_sounds: int

@export_group("Subscribed")
@export var on_play_sound_requested: SignalThreeArgs

func _ready() -> void:
	on_play_sound_requested.connect_signal(play_sound)
	
	for i in preloaded_sounds:
		_instantiate_sound_player()

func _instantiate_sound_player() -> SoundPlayer:
	var sp = sound_player_prefab.instantiate() as SoundPlayer
	add_child(sp)
	return sp
	
func _get_sound_player() -> SoundPlayer:
	for i in get_child_count():
		var sp = get_child(i) as SoundPlayer
	
		if !sp.is_busy:
			return sp
	
	return _instantiate_sound_player()

func play_sound(sound: AudioStream, pos: Vector2, pitch_random_variance: float = 0):
	_play_sound(_get_sound_player(), sound, pos, 0, 1, pitch_random_variance)

func _play_sound(sound_player: SoundPlayer, sound: AudioStream, pos: Vector2, volume: float = 0, pitch: float = 1, pitch_random_variance: float = 0):
	sound_player.play_sound(sound, pos, volume, pitch, pitch_random_variance)
