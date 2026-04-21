class_name DialogueLineData
extends Resource

@export var character: CharacterData
@export var lines: Array[String]

func _init(_character = null, _lines = null):
	self.character = _character
	self.lines = _lines
