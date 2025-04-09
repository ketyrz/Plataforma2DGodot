extends CharacterBody2D

enum EnemyState {
	walking,
	attacking,
	dead
}

@onready var hitbox: Area2D = $Hitbox
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var fall: RayCast2D = $Fall
@onready var terrain: RayCast2D = $Terrain
@onready var player_attack: RayCast2D = $PlayerAttack
@onready var player_back: RayCast2D = $PlayerBack
@onready var attack_hitbox: Area2D = $AttackHitbox

var speed = 500
var direction: int = 1
var status: EnemyState = EnemyState.walking

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	match status:
		EnemyState.walking:
			walking(delta)
		EnemyState.attacking:
			attack()
		EnemyState.dead:
			dead()

	move_and_slide()
	
func goToWalkingState():
	status = EnemyState.walking
	anim.play("walk")
	
func walking(delta: float):
	velocity.x = speed * direction * delta
	
	if !fall.is_colliding() || terrain.is_colliding():
		turn()
		
	if player_attack.is_colliding():
		goToAttackState()
		
	if player_back.is_colliding():
		turn()
	
func goToAttackState():
	status = EnemyState.attacking
	velocity.x = 0
	anim.play("attack")
	
func attack():
	if anim.frame == 2:
		attack_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		attack_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	
func goToDeadState():
	status = EnemyState.dead
	velocity.x = 0
	hitbox.queue_free()
	fall.queue_free()
	terrain.queue_free()
	player_attack.queue_free()
	player_back.queue_free()
	anim.play("dead")
	
func dead():
	pass
	
func take_damage():
	goToDeadState()

func turn():
	direction *= -1
	scale.x *= -1

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		goToWalkingState()
