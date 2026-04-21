class_name CharacterData
extends Resource

@export var name: String
@export var portrait: Texture2D

func _init(name = "", portrait = null):
	self.name = name
	self.portrait = portrait
