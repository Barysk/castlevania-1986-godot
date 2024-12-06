extends Control

@onready var score_label: Label = $MarginContainer/VBoxContainer/HBoxContainer3/HBoxContainer/Score
var score : int = 0

@onready var time_label: Label = $MarginContainer/VBoxContainer/HBoxContainer3/HBoxContainer2/Time
var time : int = 0

@onready var stage_num_label: Label = $MarginContainer/VBoxContainer/HBoxContainer3/HBoxContainer3/StageNum
var stage_num : int = 1

@onready var player_health_label: Label = $MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/HBoxContainer/PlayerHealth
var player_health : int = 16

@onready var enemy_health_label: Label = $MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/HBoxContainer2/EnemyHealth
var enemy_health : int = 16

@onready var current_item_label: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer4/Panel/CurrentItem
#Later

@onready var hearts_label: Label = $MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer2/HBoxContainer3/Hearts
var hearts : int = 0

@onready var try_counter: Label = $MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer2/HBoxContainer4/TryCounter
# Later

func _ready() -> void:
	set_score(0)
	set_timer(300)

# [ SCORE ]
func set_score(new_score: int):
	score = new_score
	score_label.text = str(score)

func add_score(add_score: int):
	score = score + add_score
	set_score(score)

func get_score(add_score: int) -> int:
	return score


# [ TIMER ]
func set_timer(new_time: int):
	time = new_time
	time_label.text = str(time)

func get_timer() -> int:
	return time

func is_timer_zero() -> bool:
	if time <= 0:
		return true
	else:
		return false


# [ PLAYER HEALTH ]
func set_player_health(new_player_health: int):
	player_health = new_player_health
	player_health_label.text = str(player_health)

func get_player_health() -> int:
	return player_health

# [ HEARTS ]
