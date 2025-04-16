extends CharacterBody2D

enum EnemyStatus { walk, dead, attack }

const SPEED = 10.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var fall_detection: RayCast2D = $FallDetection
@onready var player_detect: RayCast2D = $PlayerDetect

var status: EnemyStatus = EnemyStatus.walk
var direction: int = 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		EnemyStatus.walk:
			walk()
		EnemyStatus.dead:
			dead()
		EnemyStatus.attack:
			attack()
	
	move_and_slide()

func goToWalkState():
	status = EnemyStatus.walk
	anim.play("walk")
	
func walk():
	if !fall_detection.is_colliding():
		direction *= -1
		scale.x *= -1
	
	velocity.x = SPEED * direction
		
	if player_detect.is_colliding():
		goToAttackState()
	
func goToDeadState():
	status = EnemyStatus.dead
	hitbox.queue_free()
	velocity.x = 0
	anim.play("dead")
	
func dead():
	pass

func goToAttackState():
	status = EnemyStatus.attack
	velocity.x = 0
	anim.play("attack")
	
func attack():
	pass

func take_damage():
	goToDeadState()

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		goToWalkState()
