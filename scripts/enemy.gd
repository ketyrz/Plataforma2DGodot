extends CharacterBody2D
const SPEED = 10.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var fall_detect: RayCast2D = $FallDetect

var direction = 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	
	if !fall_detect.is_colliding():
		direction = direction * -1
		scale.x *= -1
		
	velocity.x = SPEED * direction
	
	move_and_slide()

func take_damage():
	direction = 0
	anim.play("dead")
	hitbox.queue_free()
