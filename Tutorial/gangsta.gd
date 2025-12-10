extends CharacterBody2D

@onready var target = $"../OrochiGenshin"
@onready var animation_player = $AnimationPlayer
@onready var raycast_ground = $RaycastGround
@onready var raycast_wall = $RaycastWall

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const ATTACK_RANGE = 50.0
const ATTACK_COOLDOWN = 1.5
const ATTACK_DAMAGE = 1

var health = 5
var is_dead = false
var is_attacking = false
var attack_timer = 0.0
var can_attack = true

func _ready():
	# Setup raycasts for obstacle detection
	if not raycast_ground:
		raycast_ground = RayCast2D.new()
		add_child(raycast_ground)
		raycast_ground.position = Vector2(30, 0)
		raycast_ground.target_position = Vector2(0, 50)
		raycast_ground.enabled = true
	
	if not raycast_wall:
		raycast_wall = RayCast2D.new()
		add_child(raycast_wall)
		raycast_wall.position = Vector2(0, -10)
		raycast_wall.target_position = Vector2(40, 0)
		raycast_wall.enabled = true

func _physics_process(delta: float) -> void:
	if is_dead or not target:
		return
	
	# Update attack cooldown
	if not can_attack:
		attack_timer -= delta
		if attack_timer <= 0:
			can_attack = true
	
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var distance_to_target = position.distance_to(target.position)
	
	# Check if in attack range
	if distance_to_target <= ATTACK_RANGE:
		if not is_attacking and can_attack:
			attack_target()
		velocity.x = 0
	else:
		# Move towards target
		var direction = sign(target.position.x - position.x)
		
		# Flip sprite based on direction
		if direction > 0:
			scale.x = abs(scale.x)
		else:
			scale.x = -abs(scale.x)
		
		# Check for obstacles
		raycast_ground.target_position = Vector2(30 * direction, 50)
		raycast_wall.target_position = Vector2(40 * direction, 0)
		
		# Jump if there's a wall or gap ahead
		if is_on_floor():
			if raycast_wall.is_colliding() or not raycast_ground.is_colliding():
				velocity.y = JUMP_VELOCITY
		
		# Move horizontally
		velocity.x = direction * SPEED
		
		if not is_attacking:
			play_animation("walk")
	
	move_and_slide()

func attack_target():
	is_attacking = true
	can_attack = false
	attack_timer = ATTACK_COOLDOWN
	velocity.x = 0
	
	play_animation("attack")
	
	# Deal damage to player after a short delay (attack animation time)
	await get_tree().create_timer(0.4).timeout
	
	if target and position.distance_to(target.position) <= ATTACK_RANGE:
		if target.has_method("take_damage"):
			target.take_damage(ATTACK_DAMAGE)
	
	is_attacking = false

func take_damage(damage: int):
	if is_dead:
		return
	
	health -= damage
	
	if health <= 0:
		die()
	else:
		play_animation("hurt")

func die():
	is_dead = true
	velocity = Vector2.ZERO
	play_animation("death")
	
	# Disable collision
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	# Remove after death animation
	await get_tree().create_timer(1.5).timeout
	queue_free()

func play_animation(anim_name: String):
	if animation_player and animation_player.has_animation(anim_name):
		animation_player.play(anim_name)
