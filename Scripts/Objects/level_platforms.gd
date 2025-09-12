@tool
class_name LevelPlatform
extends Node3D

#var rotator: Node3D
var static_body: StaticBody3D
var platform: MeshInstance3D
var platform_collision: CollisionShape3D
@export var platform_size: Vector3 = Vector3(10.0, 0.5, 10.0):
	set(p_platform_size):
		if p_platform_size != platform_size:
				platform_size = p_platform_size
				update_configuration_warnings()


func _get_configuration_warnings():
	var warnings = []
	
	if platform_size.x == 0.0 or platform_size.y == 0.0 or platform_size.z == 0.0:
		warnings.append("Platform size cannot be zero along any axis. Resize to avoid errors.")
	
	return warnings


func editor_setup(platform_number: int):
	platform_size = Vector3(10.0, 0.5, 10.0)
	
	static_body = StaticBody3D.new()
	static_body.name = "StaticBody3D"
	add_child(static_body)
	static_body.owner = get_tree().edited_scene_root
	
	platform = MeshInstance3D.new()
	platform.name = "Platform_Plain"
	platform.mesh = BoxMesh.new()
	platform.mesh.size = platform_size
	platform.mesh.material = StandardMaterial3D.new()
	static_body.add_child(platform)
	platform.owner = get_tree().edited_scene_root
	
	platform_collision = CollisionShape3D.new()
	platform_collision.name = "Collision"
	platform_collision.shape = ConvexPolygonShape3D.new()
	platform_collision.make_convex_from_siblings()
	static_body.add_child(platform_collision)
	platform_collision.owner = get_tree().edited_scene_root


func _process(delta):
	if Engine.is_editor_hint(): # This code executes while in the editor
		pass
	
	if !Engine.is_editor_hint(): # This code executes at runtime
		pass
	
	# Any code outside the above conditionals will run BOTH in the editor and at runtime.
	
	# Only run this code if a platform and its collision have been added by the Level Geometry node.
	if platform and platform_collision:
		# Set the mesh's size to the designer's specification
		platform.mesh.size = platform_size
		# Set the collider's size to the mesh's size
		platform_collision.make_convex_from_siblings()
