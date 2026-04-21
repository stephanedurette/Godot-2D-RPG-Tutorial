extends CanvasLayer

@export var parent_object: Control

@onready var portrait: TextureRect = $Control/Background/Portrait
@onready var text: RichTextLabel = $Control/Background/Text
@onready var name_text: RichTextLabel = $Control/Background/Name

var current_dialogue_npc: NPC
var current_dialogue_index: int

func _ready() -> void:
	DialogueEvents.on_npc_interacted.connect(_on_npc_interacted)
	DialogueEvents.on_dialogue_end_request.connect(_on_dialogue_end_request)
	
	open(false)

func _continue_dialog():
	current_dialogue_index += 1
	
	if current_dialogue_index >= current_dialogue_npc.dialogue_data.lines.size():
		_on_dialogue_end_request()
		return
	
	_update_dialogue(current_dialogue_index)	
	

func _on_dialogue_end_request():
	open(false)
	current_dialogue_npc = null

func _on_npc_interacted(npc: NPC):
	
	if current_dialogue_npc == null:
		current_dialogue_npc = npc
		open(true)	
		current_dialogue_index = 0
		portrait.texture = current_dialogue_npc.dialogue_data.character.portrait
		name_text.text = current_dialogue_npc.dialogue_data.character.name
		_update_dialogue(current_dialogue_index)
	else:
		_continue_dialog()
	
func _update_dialogue(index: int):
	text.text = current_dialogue_npc.dialogue_data.lines[index]

func open(o: bool):
	parent_object.visible = o
	
