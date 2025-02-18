extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

var doubleJumpRemaining = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		doubleJumpRemaining = true

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		else:
			if doubleJumpRemaining:
				doubleJumpRemaining = false
				velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")

	# Flip sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true	

	# Play animations
	if not is_on_floor():
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
	else:
		if velocity.x == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")

	# Get the input direction and handle the movement/deceleration.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
