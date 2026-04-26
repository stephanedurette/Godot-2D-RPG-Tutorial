extends AudioStreamPlayer

@export_group("Subscribed")
@export var on_music_play_requested: SignalOneArg

func _ready() -> void:
	on_music_play_requested.connect_signal(_on_music_play_requested)

func _on_music_play_requested(music: AudioStream):
	if (music == self.stream):
		return
	
	self.stop()
	self.stream = music
	
	if (music != null):
		self.play()
