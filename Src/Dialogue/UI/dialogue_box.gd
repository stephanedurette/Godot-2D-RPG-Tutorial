extends CanvasLayer

@export var parent_object: Control

@onready var portrait: TextureRect = $Control/Background/Portrait
@onready var text: RichTextLabel = $Control/Background/Text
@onready var name_text: RichTextLabel = $Control/Background/Name

@export var characters_per_second: float

var current_dialogue_npc: NPC
var current_dialogue_index: int

var text_crawl_tween: Tween

func _ready() -> void:
	DialogueEvents.on_npc_interacted.connect(_on_npc_interacted)
	DialogueEvents.on_dialogue_end_request.connect(_on_dialogue_end_request)
	
	open(false)

func _skip_dialog_animation():
	text_crawl_tween.kill()
	text_crawl_tween = null
	text.visible_ratio = 1
	

func _continue_dialog():
	current_dialogue_index += 1	
	text.text = current_dialogue_npc.dialogue_data.lines[current_dialogue_index]
	text.visible_ratio = 0
	
	text_crawl_tween = get_tree().create_tween()
	text_crawl_tween.tween_property(text, "visible_ratio", 1, text.text.length() / characters_per_second)
	text_crawl_tween.tween_callback(func(): text_crawl_tween = null)

func _on_dialogue_end_request():
	open(false)
	current_dialogue_npc = null

func _on_npc_interacted(npc: NPC):
	
	if current_dialogue_npc == null:
		_start_dialogue(npc)
	elif text_crawl_tween:
		_skip_dialog_animation()
	elif current_dialogue_index >= current_dialogue_npc.dialogue_data.lines.size() - 1:
		_on_dialogue_end_request()
	else:
		_continue_dialog()
	
func _start_dialogue(npc: NPC):
	current_dialogue_npc = npc
	open(true)	
	current_dialogue_index = -1
	portrait.texture = current_dialogue_npc.dialogue_data.character.portrait
	name_text.text = current_dialogue_npc.dialogue_data.character.name
	_continue_dialog()	

func open(o: bool):
	parent_object.visible = o
	
