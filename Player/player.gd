extends CharacterBody2D

@onready var player: CharacterBody2D = $"."


const SPEED = 120
const JUMP_VELOCITY = -300


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var direction : float = 0
	if is_on_floor():
		direction = Input.get_axis("go_left", "go_right")
	if direction:
		velocity.x = direction * SPEED
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
