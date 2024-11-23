extends HBoxContainer

var student_icon_scene : PackedScene = preload("res://scenes/ui/student_icon.tscn")

func _ready():
	# Make icons center themselves in their slots
	alignment = ALIGNMENT_CENTER
	# Give each slot equal space
	size_flags_horizontal = SIZE_EXPAND_FILL

func add_icon(student_name: String):
	if has_icon(student_name):  # Don't add if already exists
		return
	var student_icon = student_icon_scene.instantiate()
	add_child(student_icon)
	student_icon.set_student_name(student_name)
	
	return student_icon
	
func remove_icon(student_name: String):
	for child in get_children():
		if child.name == student_name:
			remove_child(child)
			child.queue_free()
			break
	
func has_icon(student_name: String) -> bool:
	for child in get_children():
		if child.name == student_name:  # This should now work with consistent naming
			return true
	return false
