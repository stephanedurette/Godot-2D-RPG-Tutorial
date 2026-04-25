class_name Hurtbox

extends Area2D

@export var team: TeamData

signal on_damage_taken(damage: int)

func take_hit(damage: int):
	on_damage_taken.emit(damage)

func _on_area_entered(area: Area2D) -> void:
	var hitbox = (area as Hitbox)
	if (hitbox.team != team):
		take_hit(hitbox.damage)
