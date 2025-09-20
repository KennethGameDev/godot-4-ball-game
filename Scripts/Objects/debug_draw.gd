extends Control


class Vector:
	var object: Node3D # The node to follow
	var property: String # The property to draw
	var scale_factor: float # Scale factor
	var width: float # Line width
	var color: Color # Draw color
	
	func _init(_object: Node3D, _property: String, _scale_factor: float, _width: float, _color: Color):
		object = _object
		property = _property
		scale_factor = _scale_factor
		width = _width
		color = _color
	
	func draw(node: Control, camera: Camera3D):
		var start: Vector2 = camera.unproject_position(object.global_transform.origin)
		var end: Vector2 = camera.unproject_position(object.global_transform.origin + object.get(property) * scale_factor)
		
		node.draw_line(start, end, color, width)


var vectors: Array = []


func _process(_delta: float):
	if not visible:
		return
	queue_redraw()


func _draw():
	var camera: Camera3D = get_viewport().get_camera_3d()
	for vector in vectors:
		vector.draw(self, camera)


func add_vector(object: Node3D, property: String, scale_factor: float, width: float, color: Color):
	vectors.append(Vector.new(object, property, scale_factor, width, color))
