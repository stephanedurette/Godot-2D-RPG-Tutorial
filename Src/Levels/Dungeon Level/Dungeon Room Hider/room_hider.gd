extends Node2D

@export var room_showing: bool

@export var collision_tilemap: TileMapLayer

func _ready() -> void:
	show_room(room_showing)

func show_room(s: bool):
	collision_tilemap.collision_enabled = !s
	visible = !s
