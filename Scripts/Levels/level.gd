class_name Level
extends Node

@onready var rotator = $Rotator
var direction: Array[float] = [0, 0, 0, 0]

func _ready():
	for rigid_body in rotator.get_children():
		var mesh: CSGBox3D = CSGBox3D.new()
		mesh.scale = rigid_body.get_child(0).shape.size
		rigid_body.add_child(mesh)

func _physics_process(delta):
	get_direction()

func get_direction():
	if Input.is_action_pressed("move_forward"):
		direction[0] = Input.get_action_strength("move_forward")
	else:
		direction[0] = 0
	if Input.is_action_pressed("move_right"):
		direction[1] = Input.get_action_strength("move_right")
	else:
		direction[1] = 0
	if Input.is_action_pressed("move_backward"):
		direction[2] = Input.get_action_strength("move_backward")
	else:
		direction[2] = 0
	if Input.is_action_pressed("move_left"):
		direction[3] = Input.get_action_strength("move_left")
	else:
		direction[3] = 0
