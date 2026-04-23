extends CanvasLayer

@export var item_ui_scene: PackedScene

@export var item_ui_container: Control

func _ready() -> void:
	WorldEvents.on_player_inventory_updated.connect(_on_player_inventory_updated)
	
func _on_player_inventory_updated(items: Dictionary[ItemData, int]):
	_show_inventory(items)
	
func _show_inventory(items: Dictionary[ItemData, int]):
	for i in item_ui_container.get_child_count():
		(item_ui_container.get_child(i) as ItemUI).visible = false
		
	var i: int = -1
	for key in items.keys():
		i += 1
		if item_ui_container.get_child_count() <= i:
			item_ui_container.add_child(item_ui_scene.instantiate())
		(item_ui_container.get_child(i) as ItemUI).visible = true
		(item_ui_container.get_child(i) as ItemUI).set_display(key, items[key])
