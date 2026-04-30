class_name SoundPlayer extends AudioStreamPlayer2D

var is_busy: bool

func play_sound(sound: AudioStream, pos: Vector2, volume: float = 0, pitch: float = 1, pitch_random_variance: float = 0):
	is_busy = true
	stream = sound
	global_position = pos
	volume_db = volume
	pitch_scale = pitch * (1 + randf_range(-pitch_random_variance, pitch_random_variance))
	play()

func _on_finished() -> void:
	is_busy = false
