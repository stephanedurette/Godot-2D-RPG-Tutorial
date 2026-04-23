class_name Inventory

extends Node

var items: Dictionary[ItemData, int]

signal on_inventory_updated(items: Dictionary[ItemData, int])

func add(item: ItemData, count: int):
	if (items.get(item) == null):
		items.get_or_add(item, 0)
	items[item] += count
	on_inventory_updated.emit(items)
	
func remove(item: ItemData, count: int) -> bool:
	if (has(item, count)):
		items[item] -= count
		on_inventory_updated.emit(items)
		return true
	return false
	
func has(item: ItemData, count: int) -> bool:
	if (items.get(item) == null):
		return false
		
	if (items[item] < count):
		return false
		
	return true
