class_name Ball
extends RigidBody3D


@export var speed = 0.2

var input_direction: Vector3 = Vector3.ZERO
var forward_direction: Vector3 = Vector3.ZERO
var forward_dir_angle: float = 0.0
var prev_velocity: Vector3 = Vector3.ZERO
@export var camera_speed: float = 0.5
@onready var camera_anchor: Marker3D = $CameraAnchor
@onready var base_rotator: Node3D = $H_Rotation
@onready var rigid_body = $"."


func _physics_process(_delta: float):
	handle_directional_input()


func _process(delta: float):
	camera_follow(delta)
	DebugOverlay.draw.add_vector(self, "linear_velocity", 1, 4, Color(1, 1, 1, 0.75))
	DebugOverlay.draw.add_vector(self, "forward_direction", 1, 4, Color(1, 1, 0, 0.75))
	DebugOverlay.draw.add_vector(self, "prev_velocity", 1, 4, Color(1, 0, 0, 0.75))


func handle_directional_input():
	get_direction()
	move_ball()


func get_direction() -> bool:
	var input: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	input_direction = Vector3(input.x, 0.0, input.y).normalized()
	if input_direction != Vector3.ZERO:
		forward_direction = input_direction.rotated(Vector3.UP, get_camera_rotation().y)
		return true
	else: return false


func move_ball():
	if input_direction != Vector3.ZERO:
		linear_velocity += Vector3(forward_direction.x, 0.0, forward_direction.z) * speed
		prev_velocity = linear_velocity.normalized()
		#print(angle_to_forward_dir)


func get_camera_rotation() -> Vector3:
	return base_rotator.global_transform.basis.get_euler()


func camera_follow(delta: float):
	base_rotator.global_position = camera_anchor.get_global_transform_interpolated().orthonormalized().origin
	
	forward_dir_angle = prev_velocity.signed_angle_to(forward_direction, Vector3.UP)
	#var camera_angle_dif = angle_difference(forward_dir_angle, )
	var theta: float = atan2(get_camera_rotation().y, forward_dir_angle)
	prints(forward_dir_angle, get_camera_rotation(), theta)
	#if forward_dir_angle > 0.5 or forward_dir_angle < -0.5:
		#base_rotator.rotation.y += clamp(camera_speed * delta, 0, abs(theta)) * sign(theta)
