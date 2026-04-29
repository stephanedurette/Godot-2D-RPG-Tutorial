class_name Hurtbox

extends Area2D

@export var team: TeamData

signal on_damage_taken(damage: int)
signal on_hit(hitbox: Hitbox)

func _on_area_entered(area: Area2D) -> void:
	var hitbox = (area as Hitbox)
	if (hitbox.team != team):
		on_damage_taken.emit(hitbox.damage)
		on_hit.emit(hitbox)
