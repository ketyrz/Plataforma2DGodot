extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

var didSecondJump: bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		didSecondJump = false
		if velocity.x != 0:
			anim.play("walk")
		else:
			anim.play("idle")

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			anim.play("jump")
		elif didSecondJump == false:
			velocity.y = JUMP_VELOCITY
			didSecondJump = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if velocity.x > 0:
		anim.flip_h = false
	elif velocity.x < 0:
		anim.flip_h = true
		
	move_and_slide()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("death_zone"):
		call_deferred("reload_level")
	elif area.is_in_group("level_end"):
		var next_level = area.next_level
		call_deferred("load_level", next_level)

func reload_level():
	get_tree().reload_current_scene()

func load_level(level_name: String):
	get_tree().change_scene_to_file("res://scenes/" + level_name + ".tscn")
