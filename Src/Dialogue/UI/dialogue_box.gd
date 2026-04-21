extends CanvasLayer

@export var parent_object: Control


func _ready() -> void:
	DialogueEvents.on_dialogue_requested.connect(_on_dialogue_requested)
	DialogueEvents.on_dialogue_end_request.connect(_on_dialogue_end_request)
	DialogueEvents.on_dialogue_continue_requested.connect(_on_dialogue_continue_requested)
	
	open(false)

func _on_dialogue_continue_requested():
	pass

func _on_dialogue_end_request():
	open(false)

func _on_dialogue_requested():
	open(true)

func open(o: bool):
	parent_object.visible = o
	
