extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $Path2D/PathFollow2D/StaticBody2D/CollisionShape2D
@onready var collision_shape_2d_2: CollisionShape2D = $Path2D/PathFollow2D/StaticBody2D/CollisionShape2D2
@onready var collision_shape_2d_3: CollisionShape2D = $Path2D/PathFollow2D/StaticBody2D/CollisionShape2D3

@onready var static_body_2d: StaticBody2D = $Path2D/PathFollow2D/StaticBody2D
@onready var path_follow_2d: PathFollow2D = $Path2D/PathFollow2D

var player : CharacterBody2D = null
var player_is_on_stairs : bool = false

var start_path : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_is_on_stairs:
		disable_collisions(false)
	else:
		disable_collisions(true)
	
	if player != null:
		if Input.is_action_just_pressed("go_upstairs") and not player_is_on_stairs:
			player.set_player_on_stairs(true)
			player.global_position = static_body_2d.global_position - Vector2(0, 15)
			player_is_on_stairs = true
			path_follow_2d.progress_ratio = start_path
			if start_path == 0 : print("warning start_path = 0")
		
		elif Input.is_action_pressed("go_upstairs") and player_is_on_stairs:
			path_follow_2d.progress += 50 * delta
		elif Input.is_action_pressed("go_downstairs") and player_is_on_stairs:
			path_follow_2d.progress -= 50 * delta

func disable_collisions(state: bool) -> void:
	collision_shape_2d.set_deferred("disabled", state)
	collision_shape_2d_2.set_deferred("disabled", state)
	collision_shape_2d_3.set_deferred("disabled", state)

# + Enter from start
func _on_enter_from_forward_body_entered(body: Node2D) -> void:
	print(body)
	if body.is_in_group("Player"):
		player = body
		#TODO Start from begin

# - Exit form start
func _on_enter_from_forward_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and player_is_on_stairs == false:
		player = null
		start_path = 0.01
		

# + Enter from start
func _on_enter_from_backward_body_entered(body: Node2D) -> void:
	print(body)
	if body.is_in_group("Player"):
		player = body
		start_path = 0.99
		#TODO Start from end

# - Exit form end
func _on_enter_from_backward_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and player_is_on_stairs == false:
		player = null
