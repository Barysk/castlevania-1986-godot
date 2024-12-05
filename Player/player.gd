extends CharacterBody2D

@onready var player: CharacterBody2D = $"."

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D


const SPEED = 120
const JUMP_VELOCITY = -300

var moving_right : bool = true
var is_walking : bool = false
var is_on_stairs : bool = false

func _physics_process(delta: float) -> void:
	if moving_right:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	
	if is_on_stairs:
		stairs_movement()
	else:
		default_movement(delta)
	
	move_and_slide()

func set_player_on_stairs(state: bool) -> void:
	if state != is_on_stairs:
		pass
		#TODO
	
	is_on_stairs = state

func default_movement(delta: float) -> void:
	if is_walking:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction : float = 0
	if is_on_floor():
		direction = Input.get_axis("go_left", "go_right")
		if direction > 0:
			moving_right = true
			is_walking = true
		elif direction < 0: 
			moving_right = false
			is_walking = true
		else:
			is_walking = false
	else:
		is_walking = false
	if direction:
		velocity.x = direction * SPEED
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)

func stairs_movement() -> void:
	pass

func change_camera_limits(left: int, top: int, right: int, bottom: int) -> void:
	camera_2d.limit_left = left
	camera_2d.limit_top = top
	camera_2d.limit_right = right
	camera_2d.limit_bottom = bottom
