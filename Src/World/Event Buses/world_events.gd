extends Node

@warning_ignore("unused_signal")
signal on_portal_entered(p: Portal)

@warning_ignore("unused_signal")
signal on_player_position_updated(pos: Vector2)

@warning_ignore("unused_signal")
signal on_item_collected(item: ItemData)

@warning_ignore("unused_signal")
signal on_player_inventory_updated(items: Dictionary[ItemData, int])

@warning_ignore("unused_signal")
signal on_player_health_changed(new_health: int)

@warning_ignore("unused_signal")
signal on_player_health_depleted

@warning_ignore("unused_signal")
signal on_player_max_health_changed(new_max_health: int)
