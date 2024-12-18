extends Node2D

@onready var player: CharacterBody2D = $Player

@onready var ui: Control = $CanvasLayer/UI
@onready var seconds_timer: Timer = $SecondsTimer

const MONEY_BAG = preload("res://Items/money_bag.tscn")
@onready var reveal_tresure: Area2D = $CastleEntrance/Triggers/RevealTresure
@onready var tresure_revealed: AudioStreamPlayer = $Sounds/TresureRevealed
@onready var block_broken: Area2D = $EntranceHall/Triggers/HiddenTresure/BlockBroken
@onready var sprite_2d: Sprite2D = $EntranceHall/Triggers/HiddenTresure/Sprite2D


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

func _add_item_to_tree(item):
	get_tree().root.add_child(item)
	tresure_revealed.play()

func _on_reveal_tresure_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and reveal_tresure.get_meta("is_hidden"):
		reveal_tresure.set_meta("is_hidden", false)
		var item = MONEY_BAG.instantiate()
		item.global_position = Vector2(640, 192)
		item.index = 6
		call_deferred("_add_item_to_tree", item)

func _on_block_broken_area_entered(area: Area2D) -> void:
	if area.has_meta("Hitbox"):
		if area.get_meta("Hitbox") == "player" and not block_broken.get_meta("is_broken"):
			sprite_2d.show()
			block_broken.set_meta("is_broken", true)
			var item = MONEY_BAG.instantiate()
			item.global_position = Vector2(1784, 200)
			item.index = 4
			call_deferred("_add_item_to_tree", item)
