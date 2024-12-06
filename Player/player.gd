extends CharacterBody2D

@onready var player: CharacterBody2D = $"."

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D

@onready var collision_hitbox: CollisionShape2D = $Hitbox/CollisionHitbox

const SPEED = 80
const JUMP_VELOCITY = -300

var moving_right : bool = true
var is_walking : bool = false
var is_on_stairs : bool = false
var stairs_directed_rigth : bool = false
var is_attacking : bool = false

#TODO attack

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("attack") and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite_2d.play("attack_melee")
		collision_hitbox.set_deferred("disabled", false)
		is_attacking = true
	
	if not animated_sprite_2d.is_playing():
		is_attacking = false
		collision_hitbox.set_deferred("disabled", true)
	
	if not is_attacking:
		if is_on_stairs:
			stairs_movement()
		else:
			default_movement(delta)
	
	move_and_slide()

func set_player_on_stairs(state: bool, stairs_going_right: bool) -> void:
	stairs_directed_rigth = stairs_going_right
	is_on_stairs = state

func default_movement(_delta: float) -> void:
	if moving_right:
		animated_sprite_2d.flip_h = true
		collision_hitbox.position = Vector2(18, 0)
	else:
		animated_sprite_2d.flip_h = false
		collision_hitbox.position = Vector2(-18, 0)
	
	if is_walking:
		animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("idle")
	
	
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
	if Input.is_action_pressed("go_upstairs"):
		if stairs_directed_rigth and animated_sprite_2d.flip_h == false:
			animated_sprite_2d.flip_h = true
		elif not stairs_directed_rigth and animated_sprite_2d.flip_h == true:
			animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("stairs_walk_up")
	elif Input.is_action_pressed("go_downstairs"):
		if stairs_directed_rigth and animated_sprite_2d.flip_h == true:
			animated_sprite_2d.flip_h = false
		elif not stairs_directed_rigth and animated_sprite_2d.flip_h == false:
			animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("stairs_walk_down")
	else:
		animated_sprite_2d.stop()



func change_camera_limits(left: int, top: int, right: int, bottom: int) -> void:
	camera_2d.limit_left = left
	camera_2d.limit_top = top
	camera_2d.limit_right = right
	camera_2d.limit_bottom = bottom


func _on_q_free_area_body_exited(body: Node2D) -> void:
	#print(body)
	if body.has_meta("Enemy"):
		if body.get_meta("Enemy") == "zombie":
			body.queue_free()
