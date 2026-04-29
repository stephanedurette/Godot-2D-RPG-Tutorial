class_name HitFlasher extends Node

@export_group("Settings")
@export var flash_time: float
@export var flash_color: Color

@export_group("External References")
@export var sprite: Sprite2D

@onready var timer := $Timer

var sprite_original_color: Color

func _ready() -> void:
	sprite_original_color = sprite.self_modulate

func flash(color = flash_color, time = flash_time):
	sprite.self_modulate = color
	timer.start(time)
	
func _on_timer_timeout() -> void:
	sprite.self_modulate = sprite_original_color
