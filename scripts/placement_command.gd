extends Node
class_name PlacementCommand

var friend_name: String
var student : Student
var target_desk: Student  # The empty desk being filled
var grid_position: Vector2i
var state_snapshot: Dictionary
var level: Node
var is_valid: bool = true


func _init(student_: Student, desk: Student, pos: Vector2i, state_: Dictionary, level_node: Node, valid: bool):
	student = student_
	friend_name = student_.name
	target_desk = desk
	grid_position = pos
	state_snapshot = state_.duplicate(true)
	level = level_node
	is_valid = valid
	
func get_level() -> Node:
	return get_node("/root/Level")

func execute() -> void:
	target_desk.highlight(is_valid)
	
	target_desk.set_student_name(friend_name)
	target_desk.grid_position = grid_position
	target_desk.is_friend = true
	level.friend_placement_panel.remove_icon(friend_name)
	level.update_classroom_array(target_desk, friend_name)  # Update array BEFORE applying state
	apply_state_changes()  # Then apply state changes
	level.current_note_holder = target_desk
	
	# Check validity of student placements and upate note chain
	level.validate_all_students()
	level.calculate_note_chain()
	
	level.update_preview()

func undo() -> void:
	target_desk.set_student_name("empty")
	target_desk.is_friend = false
	level.update_classroom_array(target_desk, "empty")
	level.friend_placement_panel.add_icon(friend_name)
	
	target_desk.highlight(true)
	
	var classroom_state = level.classroom.duplicate(true)
	restore_state_from_snapshot()
	level.classroom = classroom_state 
	
	# Set note holder
	if level.planner.current_index > 0:
		level.current_note_holder = level.planner.commands[level.planner.current_index - 1].target_desk
	else:
		level.current_note_holder = level.player
		
	level.validate_all_students()
	level.calculate_note_chain()
	
	level.update_preview()

func apply_state_changes():
	# Apply state changes from snapshot
	level.classroom = state_snapshot.classroom.duplicate(true)
	
func restore_state_from_snapshot():
	# Restore state from snapshot
	level.classroom = state_snapshot.classroom.duplicate(true)
