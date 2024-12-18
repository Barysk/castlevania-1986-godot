extends Node2D

@export var spawn_enemy_type : int = 0
const PANTERA = preload("res://Enemies/Pantera/pantera.tscn")
const ZOMBIE = preload("res://Enemies/Zombie/zombie.tscn")
@onready var enemy_spawner: Node2D = $"."
@onready var timer: Timer = $Timer
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

var is_area_qfree : bool = false
var is_area_screen : bool = false
var is_area_empty : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemy(ENEMY: PackedScene):
	var enemy = ENEMY.instantiate()
	enemy.global_position = enemy_spawner.global_position
	get_tree().root.add_child(enemy)


func _on_timer_timeout() -> void:
	if is_area_empty and is_area_qfree and not is_area_screen and not visible_on_screen_notifier_2d.is_on_screen():
		match spawn_enemy_type:
			1:
				if get_tree().get_nodes_in_group("Zombie").size() <= 20:
					spawn_enemy(ZOMBIE)
			2:
				spawn_enemy(PANTERA)
			_:
				print("Probably forgot to set spawn_enemy_type at " + name)
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


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		is_area_empty = false


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		is_area_empty = true
