extends CharacterBody2D



func _on_health_on_health_changed(new_value: int) -> void:
	print(new_value)


func _on_health_on_health_depleted() -> void:
	print("dead")
