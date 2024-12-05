extends Control

@onready var score: Label = $MarginContainer/VBoxContainer/HBoxContainer3/HBoxContainer/Score
@onready var time: Label = $MarginContainer/VBoxContainer/HBoxContainer3/HBoxContainer2/Time
@onready var stage_num: Label = $MarginContainer/VBoxContainer/HBoxContainer3/HBoxContainer3/StageNum

@onready var player_health: Label = $MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/HBoxContainer/PlayerHealth
@onready var enemy_health: Label = $MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer/HBoxContainer2/EnemyHealth

@onready var current_item: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer4/Panel/CurrentItem

@onready var hearts: Label = $MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer2/HBoxContainer3/Hearts
@onready var try_counter: Label = $MarginContainer/VBoxContainer/HBoxContainer4/VBoxContainer2/HBoxContainer4/TryCounter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
