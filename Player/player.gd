extends CharacterBody2D

@onready var ui: Control = $"../CanvasLayer/UI"
@onready var player: CharacterBody2D = $"."

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera_2d: Camera2D = $Camera2D

@onready var collision_hitbox: CollisionShape2D = $Hitbox/CollisionHitbox
@onready var bicz: AnimatedSprite2D = $Bicz
@onready var bicz_a: AudioStreamPlayer = $Sounds/Bicz
@onready var hurt: AudioStreamPlayer = $Sounds/Hurt

const SPEED = 80
const JUMP_VELOCITY = -300

var moving_right : bool = true
var is_walking : bool = false
var is_on_stairs : bool = false
var stairs_directed_rigth : bool = false
var is_attacking : bool = false

# [ STATS ]
var score : int = 0		# 0
@onready var score_picked_up: AudioStreamPlayer = $Sounds/ScorePickedUp
var health : int = 16	# 1
var hearts : int = 5	# 2
@onready var heart_picked_up: AudioStreamPlayer = $Sounds/HeartPickedUp
var tries : int = 3		# 3

func _ready() -> void:
	update_ui()

func _physics_process(delta: float) -> void:
	
	if animated_sprite_2d.animation == "get_damage" and animated_sprite_2d.is_playing():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	elif is_on_floor() and animated_sprite_2d.animation == "attack_melee" or "get_damage":
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("attack") and not is_on_stairs:
		animated_sprite_2d.play("attack_melee")
		is_attacking = true
		
	
	if animated_sprite_2d.animation == "attack_melee" and animated_sprite_2d.frame == 2:
		if bicz_a.playing == false:
			bicz_a.play()
		bicz.show()
		collision_hitbox.set_deferred("disabled", false)
		
	if not animated_sprite_2d.is_playing():
		is_attacking = false
		bicz.hide()
		collision_hitbox.set_deferred("disabled", true)
	
	if not is_attacking:
		if is_on_stairs:
			stairs_movement()
		else:
			default_movement(delta)
	
	move_and_slide()

func deal_damage(value: int):
	health -= value
	set_stat(1, health)
	animated_sprite_2d.play("get_damage")
	if hurt.playing == false:
			hurt.play()

func set_player_on_stairs(state: bool, stairs_going_right: bool) -> void:
	stairs_directed_rigth = stairs_going_right
	is_on_stairs = state

func default_movement(_delta: float) -> void:
	if moving_right:
		animated_sprite_2d.flip_h = true
		collision_hitbox.position = Vector2(18, 0)
		bicz.flip_h = true
		bicz.position = Vector2(22, -4)
	else:
		animated_sprite_2d.flip_h = false
		collision_hitbox.position = Vector2(-18, 0)
		bicz.flip_h = false
		bicz.position = Vector2(-22, -4)
	
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

func update_ui() -> void:
	ui.set_score(score)
	ui.set_player_health(health)
	ui.set_hearts(hearts)
	ui.set_tries(tries)

func add_stat(stat_index: int, value: int):
	match stat_index:
		0: 
			score += value
			score_picked_up.play()
		1: health += value
		2: 
			hearts += value
			heart_picked_up.play()
		3: tries += value
		_: print("No such thing to set")
	
	update_ui()

func set_stat(stat_index: int, value: int):
	match stat_index:
		0: 
			score = value
			score_picked_up.play()
		1: health = value
		2: 
			hearts = value
			heart_picked_up.play()
		3: tries = value
		_: print("No such thing to set")
	
	update_ui()

func get_stat(stat_index: int) -> int:
	match stat_index:
		0: return score
		1: return health
		2: return hearts
		3: return tries
		_:
			print("No such thing to return")
			return -1

func _on_q_free_area_body_exited(body: Node2D) -> void:
	#print(body)
	if body.is_in_group("Enemy"):
		body.queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.has_meta("Hitbox"):
		if area.get_meta("Hitbox") == "enemy":
			deal_damage(1)
