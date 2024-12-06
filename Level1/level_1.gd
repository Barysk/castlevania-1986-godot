extends Node2D

@onready var player: CharacterBody2D = $Player

@onready var ui: Control = $CanvasLayer/UI
@onready var seconds_timer: Timer = $SecondsTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Players spawning position knowing that the level starts 64 pixel lower
func spawn_player_at_pos(x: float, y: float) -> Vector2:
	y = y - 64
	return Vector2(x, y)

# move to entrance hall
func _on_scene_to_entr_hall_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.position = spawn_player_at_pos(816, 225)
		body.change_camera_limits(768, 0, 2304, 256)


func _on_seconds_timer_timeout() -> void:
	ui.set_timer(ui.get_timer() - 1)
	seconds_timer.start()
