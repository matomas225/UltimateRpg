extends CharacterBody2D

# Movement tuning constants
const MOVE_SPEED = 160.0
const JUMP_FORCE = -200.0
const GRAVITY = 1000.0
const ACCELERATION = 1200.0
const AIR_ACCELERATION = 600.0
const FRICTION = 1000.0
const MAX_FALL_SPEED = 900.0

# Dash variables
const DASH_SPEED = 250.0      # Speed during dash
const DASH_TIME = 0.2         # Dash duration in seconds
const DASH_COOLDOWN = 2     # Time between dashes

# Dash state
var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = 0

# Optional: Coyote time and jump buffer
const COYOTE_TIME = 0.1
const JUMP_BUFFER_TIME = 0.1

var coyote_timer = 0.0
var jump_buffer_timer = 0.0

func _physics_process(delta: float) -> void:
	# Update dash cooldown timer
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	# Handle ongoing dash
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			dash_cooldown_timer = DASH_COOLDOWN

	if is_dashing:
		# During dash: move horizontally at dash speed, ignore gravity & normal input
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0  # Optionally lock vertical movement during dash
	else:
		# Handle gravity
		if not is_on_floor():
			velocity.y += GRAVITY * delta
			velocity.y = min(velocity.y, MAX_FALL_SPEED)
		elif velocity.y > 0:
			velocity.y = 0

		# Update coyote time
		if is_on_floor():
			coyote_timer = COYOTE_TIME
		else:
			coyote_timer -= delta

		# Update jump buffer
		if Input.is_action_just_pressed("ui_accept"):
			jump_buffer_timer = JUMP_BUFFER_TIME
		else:
			jump_buffer_timer -= delta

		# Handle jump (with coyote time and buffer)
		if jump_buffer_timer > 0 and coyote_timer > 0:
			velocity.y = JUMP_FORCE
			jump_buffer_timer = 0
			coyote_timer = 0

		# Get horizontal input direction
		var input_dir = Input.get_axis("ui_left", "ui_right")
		var accel = ACCELERATION if is_on_floor() else AIR_ACCELERATION

		# Start dash if Shift pressed, dash ready, and input direction non-zero
		if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and input_dir != 0:
			is_dashing = true
			dash_timer = DASH_TIME
			dash_direction = input_dir
		else:
			# Normal horizontal movement when not dashing
			if input_dir != 0:
				velocity.x = move_toward(velocity.x, input_dir * MOVE_SPEED, accel * delta)
			else:
				if is_on_floor():
					velocity.x = 0

	# Finally, move the character
	move_and_slide()
