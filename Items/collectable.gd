extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var index: int = 0 #Needet to diffirentiate the objects

func _ready() -> void:
	match index:
		3: 
			animated_sprite_2d.frame = 0
			animated_sprite_2d.play("default")
		4: 
			animated_sprite_2d.frame = 1
			animated_sprite_2d.play("default")
		5:
			animated_sprite_2d.frame = 2
			animated_sprite_2d.play("default")
		6:
			animated_sprite_2d.play("flickering")
		_:
			pass

func _physics_process(delta: float) -> void:
	if is_on_floor():
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		match index:
			1: body.add_stat(2, 5)
			2: body.add_stat(2, 1)
			3: body.add_stat(0, 100)
			4: body.add_stat(0, 400)
			5: body.add_stat(0, 700)
			6: body.add_stat(0, 1000)
		queue_free()
