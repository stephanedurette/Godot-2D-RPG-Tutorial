class_name ItemUI

extends Control

@onready var image_texture: TextureRect = $HBoxContainer/Image
@onready var count_text: Label = $HBoxContainer/Count

func set_display(item: ItemData, count: int):
	image_texture.texture = item.image
	count_text.text = "x %d" % [count]
