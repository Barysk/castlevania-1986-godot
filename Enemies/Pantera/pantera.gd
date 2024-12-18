extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var has_seen_player : bool = false
var has_jumped : bool = false
var direction = 0

enum Action {
	IDLE,
	RUN,
	JUMP,
}

var action_state : Action = Action.IDLE

func _physics_process(delta: float) -> void:
	match action_state:
		Action.IDLE: 
			if not is_on_floor():
				velocity += get_gravity() * delta
		Action.RUN: 
			animated_sprite_2d.play("run")
			if not is_on_floor():
				has_jumped = true
				action_state = Action.JUMP
		Action.JUMP: 
			animated_sprite_2d.play("jump")
			velocity += get_gravity() * delta
			if is_on_floor() and has_jumped:
				has_jumped = false
				direction *= -1
				match direction:
					1:
						animated_sprite_2d.flip_h = true
					-1:
						animated_sprite_2d.flip_h = false
				action_state = Action.RUN
	
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


func _on_detection_left_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not has_seen_player:
		animated_sprite_2d.flip_h = false
		has_seen_player = true
		direction = -1
		action_state = Action.RUN

func _on_detection_right_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not has_seen_player:
		animated_sprite_2d.flip_h = true
		has_seen_player = true
		direction = 1
		action_state = Action.RUN


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.has_meta("Hitbox"):
		if area.get_meta("Hitbox") == "player":
			queue_free()
