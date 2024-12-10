extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 50
const JUMP_VELOCITY = -400.0

var direction : int

func _ready() -> void:
	direction = int([1, -1].pick_random())

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if direction > 0:
		animated_sprite_2d.flip_h = true
	elif direction < 0:
		animated_sprite_2d.flip_h = false
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	if is_on_wall():
		match direction:
			1: direction = -1
			-1: direction = 1
			_: print("no way!")



func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	if area.has_meta("Hitbox"):
		if area.get_meta("Hitbox") == "player":
			queue_free()
