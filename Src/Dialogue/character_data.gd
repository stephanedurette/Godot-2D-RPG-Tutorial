class_name CharacterData
extends Resource

@export var name: String
@export var portrait: Texture2D

func _init(_name = "", _portrait = null):
	self.name = _name
	self.portrait = _portrait
