extends Node2D

const ZOMBIE = preload("res://Enemies/Zombie/zombie.tscn")
@onready var enemy_spawner: Node2D = $"."
@onready var timer: Timer = $Timer
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var is_area_qfree : bool = false
var is_area_screen : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemy():
	var zombie = ZOMBIE.instantiate()
	zombie.global_position = enemy_spawner.global_position
	get_tree().root.add_child(zombie)


func _on_timer_timeout() -> void:
	if get_tree().get_nodes_in_group("Zombie").size() <= 20:
		if is_area_qfree and not is_area_screen and not visible_on_screen_notifier_2d.is_on_screen() :
			if randi_range(1, 10):
				spawn_enemy()
	timer.start()


func _on_area_entered(area: Area2D) -> void:
	if area.has_meta("AreaDetection"):
		if area.get_meta("AreaDetection") == "qfree":
			is_area_qfree = true
		elif area.get_meta("AreaDetection") == "screen":
			is_area_screen = true


func _on_area_exited(area: Area2D) -> void:
	if area.has_meta("AreaDetection"):
		if area.get_meta("AreaDetection") == "qfree":
			is_area_qfree = false
		elif area.get_meta("AreaDetection") == "screen":
			is_area_screen = false
