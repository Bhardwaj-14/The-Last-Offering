extends CharacterBody2D

const WALK_SPEED = 180.0
const RUN_SPEED = 320.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 1500.0
const FRICTION = 1200.0

@onready var anim = $AnimatedSprite2D
var is_attacking = false

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Attack handling
	if Input.is_action_just_pressed("attack") and not is_attacking and is_on_floor():
		is_attacking = true
		anim.play("attack")
		velocity.x = 0
	
	# Skip movement input during attack
	if is_attacking:
		move_and_slide()
		return
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Movement input
	var direction = Input.get_axis("move_left", "move_right")
	var speed = RUN_SPEED if Input.is_action_pressed("run") else WALK_SPEED
	
	# Apply movement
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * speed, ACCELERATION * delta)
		anim.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	# Animation state machine
	if not is_on_floor():
		anim.play("jump")
	elif direction != 0:
		if abs(velocity.x) > WALK_SPEED * 1.1:  # Speed threshold
			anim.play("run")
		else:
			anim.play("walk")
	else:
		anim.play("idle")
	
	move_and_slide()

func _on_animated_sprite_2d_animation_finished() -> void:
	if anim.animation == "attack":
		is_attacking = false
