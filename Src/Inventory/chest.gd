class_name Chest

extends StaticBody2D

@export var item: ItemData
@export var on_item_collected: SignalOneArg

@onready var animated_sprite: AnimatedSprite2D= $"Sprite"
@onready var item_sprite: Sprite2D = $ItemImage
@onready var item_display_timer: Timer = $"ItemDisplayTimer"

var open
var player_in_position

func _ready() -> void:
	item_sprite.texture = item.image
	
func interact():
	if (open || !player_in_position):
		return
		
	_collect_item()
	open = true

func _collect_item():
	animated_sprite.play("open")
	item_sprite.visible = true
	item_display_timer.start()
	on_item_collected.emit(item)

func _on_player_area_body_entered(_body: Node2D) -> void:
	player_in_position = true


func _on_player_area_body_exited(_body: Node2D) -> void:
	player_in_position = false


func _on_item_display_timer_timeout() -> void:
	item_sprite.visible = false
