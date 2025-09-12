class_name Ball
extends RigidBody3D


const SPEED = 5.0

var input_direction: Vector2 = Vector2.ZERO
@onready var camera_anchor: Marker3D = $CameraAnchor
@onready var base_rotator: Node3D = $H_Rotation


func _physics_process(delta: float):
	handle_directional_input(delta)


func _process(delta: float):
	base_rotator.global_position = camera_anchor.get_global_transform_interpolated().orthonormalized().origin


func handle_directional_input(delta: float):
	get_direction()
	move_ball(delta)


func get_direction() -> Vector2:
	input_direction.x = Input.get_axis("move_left", "move_right")
	input_direction.y = Input.get_axis("move_backward", "move_forward")
	
	return input_direction


func move_ball(delta: float):	
	if input_direction != Vector2.ZERO:
		add_constant_force(Vector3(input_direction.x * delta, 0.0, input_direction.y * delta), Vector3(0.0, 0.5, 0.0))
