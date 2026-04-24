class_name LevelCamera

extends Camera2D

@onready var player_detect_area: Area2D = $PlayerDetectArea
@onready var player_detect_area_collider: CollisionShape2D = $PlayerDetectArea/CollisionShape2D

var following_body: Node2D

func _ready() -> void:
	_setup_collider()
	player_detect_area.reparent.call_deferred(get_parent())

func _process(_delta: float) -> void:
	if (following_body == null):
		return
	global_position = following_body.global_position

func _setup_collider():
	var shape = player_detect_area_collider.shape as RectangleShape2D
	
	player_detect_area_collider.global_position = Vector2((limit_right + limit_left) / 2.0, (limit_bottom + limit_top) / 2.0)
	shape.size = Vector2((limit_right - limit_left), (limit_bottom - limit_top))

func _on_player_detect_area_body_entered(body: Node2D) -> void:
	following_body = body
	global_position = following_body.global_position
	make_current()
	print("entered")

func _on_player_detect_area_body_exited(_body: Node2D) -> void:
	following_body = null
	print("exited")
