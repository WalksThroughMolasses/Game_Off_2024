extends Control

var selected_student : Student
var drop_target
var is_previewing_placement : bool

signal student_placed(student, seat_position)
signal return_student_to_panel(student)

@onready var level = get_node("/root/Level") # or however your scene is structured

func _ready():
	
	# connect signals
	connect("student_placed", level._on_student_placed)
	connect("return_student_to_panel", level._on_student_return_to_panel)

func _process(_delta):
	global_position = get_global_mouse_position()
	
	if Input.is_action_just_released("click"):
		if is_previewing_placement:
			drop_target.character_art.modulate.a = 1 # adjust from previewing half alpha to full alpha
			student_placed.emit(selected_student, drop_target)
			if !selected_student is Icon:
				selected_student.set_desk_empty()
		else:
			return_student_to_panel.emit(selected_student)
		queue_free()
	
func _on_area_2d_area_entered(area):
	drop_target = area.get_parent()
	if drop_target is Student:
		if drop_target.empty_desk:
			drop_target.show_preview(selected_student.name)
			is_previewing_placement = true
	#else: # Is friend placement panel
		#

func _on_area_2d_area_exited(area):
	drop_target = area.get_parent()
	if drop_target is Student:
		if drop_target.empty_desk:
			drop_target.hide_preview()
			is_previewing_placement = false
