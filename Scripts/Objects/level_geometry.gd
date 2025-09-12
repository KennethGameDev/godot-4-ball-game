@tool
class_name LevelGeometry
extends Node3D

var platform_array_size: int
var previous_platform_array: Array[Node3D]
@export var platform_types: Array[PackedScene]:
	set(p_platform_types):
		if p_platform_types != platform_types:
			platform_types = p_platform_types
			update_configuration_warnings()
@export var level_platforms: Array[Node3D]:
	set(p_level_platforms):
		if p_level_platforms != level_platforms:
			level_platforms = p_level_platforms
			update_configuration_warnings()


func _get_configuration_warnings():
	var warnings = []
	
	if EditorInterface.get_edited_scene_root() is LevelGeometry:
		warnings.append("Add this scene to another scene to add platforms.\nThis prevents accidentally editing all existing instances of this scene throughout the project.")
	else:
		if platform_types.is_empty():
			warnings.append("Add at least one platform type.")
		if level_platforms.is_empty():
			warnings.append("Add at least one platform.")
	
	return warnings


func _ready():
	pass


func _process(delta):
	if Engine.is_editor_hint():
		if EditorInterface.get_edited_scene_root() is not LevelGeometry:
			if platform_array_size != level_platforms.size():
				update_platform_array()
				platform_array_size = level_platforms.size()
		else:
			update_platform_array(0)


func update_platform_array(clear_array: int = 1):
	if clear_array == 1:
		# If we're adding a platform
		if platform_array_size < level_platforms.size():
			level_platforms[platform_array_size] = LevelPlatform.new()
			level_platforms[platform_array_size].name = generate_platform_name()
			add_child(level_platforms[platform_array_size])
			level_platforms[platform_array_size].owner = get_tree().edited_scene_root
			level_platforms[platform_array_size].editor_setup(platform_array_size + 1)
		
		# If we're removing a platform
		if platform_array_size > level_platforms.size():
			find_child(find_missing_platform_name(previous_platform_array, level_platforms)).queue_free()
	elif clear_array == 0:
		while level_platforms.size() > 0:
			var platf: Node3D = level_platforms.pop_back()
			if platf:
				platf.queue_free()
	
	previous_platform_array = level_platforms


func generate_platform_name() -> String:
	# If this is the first platform, just give it an ID of 1.
	if level_platforms.size() == 1:
		return "Plat %d" % 1
	else:	# Otherwise, get the ID of the last instantiated platform in the list from its name and add 1 to it.
		return "Plat %d" % (level_platforms[level_platforms.size() - 2].name.split(" ")[1].to_int() + 1)


func find_missing_platform_name(prev_array: Array, new_array: Array) -> String:
	var missing_platform_name: String = ""
	
	for platform in prev_array:
		if !new_array.has(platform):
			missing_platform_name = platform.name
	
	return missing_platform_name
