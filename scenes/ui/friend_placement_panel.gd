extends Control

var student_icon_scene : PackedScene = preload("res://scenes/ui/student_icon.tscn")
@onready var grid_container = $Panel/GridContainer

func _ready():
	pass
	## Make icons center themselves in their slots
	#grid_container.alignment = GridContainer.ALIGNMENT_CENTER
	## Give each slot equal space
	#grid_container.size_flags_horizontal = GridContainer.SIZE_EXPAND_FILL

func add_icon(student_name: String):
	if has_icon(student_name):  # Don't add if already exists
		return
	var student_icon = student_icon_scene.instantiate()
	grid_container.add_child(student_icon)
	student_icon.set_student_name(student_name)
	
	return student_icon
	
func remove_icon(student_name: String):
	for child in grid_container.get_children():
		if child.name == student_name:
			grid_container.remove_child(child)
			child.queue_free()
			break
	
func has_icon(student_name: String) -> bool:
	for child in grid_container.get_children():
		if child.name == student_name:  # This should now work with consistent naming
			return true
	return false
