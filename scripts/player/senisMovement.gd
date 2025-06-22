extends CharacterBody2D

@onready var cam = $Camera2D
@export var camera_offset_amount := 40

@onready var walking_on_grass: AudioStreamPlayer2D = $WalkingOnGrass
@onready var landing_on_grass: AudioStreamPlayer2D = $LandingOnGrass

var was_walking = false
var was_on_floor = false
var has_landed_once = false

const MOVE_SPEED = 160.0
const JUMP_FORCE = -200.0
const GRAVITY = 1000.0
const ACCELERATION = 1200.0
const AIR_ACCELERATION = 600.0
const FRICTION = 1000.0
const MAX_FALL_SPEED = 900.0
const LANDING_VELOCITY_THRESHOLD = 300.0

const DASH_SPEED = 250.0
const DASH_TIME = 0.2
const DASH_COOLDOWN = 2

var is_dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var dash_direction = 0

const COYOTE_TIME = 0.1
const JUMP_BUFFER_TIME = 0.1

var coyote_timer = 0.0
var jump_buffer_timer = 0.0

func _physics_process(delta: float) -> void:
	handle_dash_timers(delta)
	handle_movement(delta)
	play_sounds()
	var vertical_velocity_before_slide = velocity.y
	move_and_slide()
	handle_landing_sound(vertical_velocity_before_slide)
	update_camera(delta)

func handle_dash_timers(delta):
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			dash_cooldown_timer = DASH_COOLDOWN

func handle_movement(delta):
	if is_dashing:
		velocity.x = dash_direction * DASH_SPEED
		velocity.y = 0
		return
	
	apply_gravity(delta)
	handle_jump_timers(delta)
	handle_horizontal_movement(delta)

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		velocity.y = min(velocity.y, MAX_FALL_SPEED)
	elif velocity.y > 0:
		velocity.y = 0

func handle_jump_timers(delta):
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta

	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer -= delta

	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_FORCE
		jump_buffer_timer = 0
		coyote_timer = 0

func handle_horizontal_movement(delta):
	var input_dir = Input.get_axis("ui_left", "ui_right")
	var accel = ACCELERATION if is_on_floor() else AIR_ACCELERATION

	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and input_dir != 0:
		is_dashing = true
		dash_timer = DASH_TIME
		dash_direction = input_dir
	else:
		if input_dir != 0:
			velocity.x = move_toward(velocity.x, input_dir * MOVE_SPEED, accel * delta)
		else:
			if is_on_floor():
				velocity.x = 0

func play_sounds():
	var is_walking_now = is_on_floor() and abs(velocity.x) > 5
	if is_walking_now and not was_walking:
		walking_on_grass.play()
	elif not is_walking_now and was_walking:
		walking_on_grass.stop()
	was_walking = is_walking_now

func handle_landing_sound(vertical_velocity_before_slide):

	if is_on_floor() and not was_on_floor and vertical_velocity_before_slide > LANDING_VELOCITY_THRESHOLD and has_landed_once:
		if not landing_on_grass.playing:
			landing_on_grass.play()
	if is_on_floor() and not has_landed_once:
		has_landed_once = true
	was_on_floor = is_on_floor()

func update_camera(delta):
	const CAMERA_LERP_SPEED = 4.0
	var target_offset_x = 0.0
	var movement_direction = sign(velocity.x)

	if abs(velocity.x) > 10:
		target_offset_x = movement_direction * camera_offset_amount

	cam.offset.x = lerp(cam.offset.x, target_offset_x, CAMERA_LERP_SPEED * delta)
