class_name DialogueLineData
extends Resource

@export var character: CharacterData
@export var lines: Array[String]

func _init(character = null, lines = null):
	self.character = character
	self.lines = lines
