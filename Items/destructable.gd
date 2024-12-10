extends Node2D

@onready var spawning_place: Node2D = $"."
@onready var hurtbox: Area2D = $Hurtbox
@export var spawn_item_on_destruct : int = 0 ## Index of item that must be spawned on destruction

const FIVE_HEART = preload("res://Items/five_heart.tscn")
const ONE_HEART = preload("res://Items/one_heart.tscn")
const MONEY_BAG = preload("res://Items/money_bag.tscn")

func spawn_item(object_index: int):
	match object_index:
		1:
			spawn(FIVE_HEART)
		2:
			spawn(ONE_HEART)
		3, 4, 5, 6:
			spawn(MONEY_BAG)
		_: 
			pass

func spawn(ITEM: PackedScene):
	var item = ITEM.instantiate()
	item.global_position = spawning_place.global_position
	#if spawn_item_on_destruct == 1 or 2:
	item.index = spawn_item_on_destruct
	# Defer adding the item to the scene tree
	call_deferred("_add_item_to_tree", item)

func _add_item_to_tree(item):
	get_tree().root.add_child(item)

func on_destruct():
	spawn_item(spawn_item_on_destruct)
	queue_free()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.has_meta("Hitbox"):
		if area.get_meta("Hitbox") == "player":
			on_destruct()
