extends Node2D

@onready var arm_left = $ArmLeft
@onready var arm_right = $ArmRight

var smoothing_speed := 10.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	var mouse_pos = get_global_mouse_position()

	var dir_left = (mouse_pos - arm_left.global_position).normalized()
	var dir_right = (mouse_pos - arm_right.global_position).normalized()

	var target_angle_left = dir_left.angle()
	var target_angle_right = dir_right.angle()

	arm_left.rotation = lerp_angle(arm_left.rotation, target_angle_left, smoothing_speed * delta)
	arm_right.rotation = lerp_angle(arm_right.rotation, target_angle_right, smoothing_speed * delta)
	
	queue_redraw()


func _draw():
	draw_circle(Vector2.ZERO, 5, Color.WHITE)
	draw_line(Vector2.ZERO, get_local_mouse_position(), Color.RED, 2)
