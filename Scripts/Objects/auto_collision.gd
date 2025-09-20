@tool
extends Node

@export_tool_button("Re-Generate Collision") var generate = func generate_collision():
	var collision: CollisionShape3D = get_child(0).get_child(0)
	
	if collision:
		collision.make_convex_from_siblings()
	else:
		print_debug("Invalid Collision Object.")
