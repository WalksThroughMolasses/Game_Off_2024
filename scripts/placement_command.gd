extends Node
class_name PlacementCommand

var friend_name: String
var student : Student
var target_desk: Student  # The empty desk being filled
var grid_position: Vector2i
var state_snapshot: Dictionary
var level: Node
var is_valid: bool = true
#
#
#func _init(student_: Student, desk: Student, pos: Vector2i, state_: Dictionary, level_node: Node, valid: bool):
	#student = student_
	#friend_name = student_.name
	#target_desk = desk
	#grid_position = pos
	#state_snapshot = state_.duplicate(true)
	#level = level_node
	#is_valid = valid
	
func get_level() -> Node:
	return get_node("/root/Level")
	
func add_placement(student: Student, target_desk: Student) -> bool:
	# Validate placement
	var valid = level.is_valid_placement(student, target_desk)
	
	var grid_pos = target_desk.grid_position
	
	level.update_classroom_array(target_desk, student.name)

	# Execute the preview
	execute()
	return true

func execute() -> void:
	target_desk.highlight(is_valid)
	target_desk.set_student_name(friend_name)
	target_desk.grid_position = grid_position
	target_desk.empty_desk = false
	level.friend_placement_panel.remove_icon(friend_name)
	level.update_classroom_array(target_desk, friend_name)
	level.current_note_holder = target_desk
	
	# Check validity of student placements and update note chain
	level.validate_all_students()
	level.calculate_note_chain()
	level.update_preview()
