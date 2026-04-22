extends Node2D

@export var room_showing: bool

@export var collision_tilemap: TileMapLayer

func _ready() -> void:
	_toogle_room_visible(room_showing)

func _toogle_room_visible(is_room_showing: bool):
	collision_tilemap.collision_enabled = !is_room_showing
	visible = !is_room_showing

func show_room():
	_toogle_room_visible(true)
	
func hide_room():
	_toogle_room_visible(false)
