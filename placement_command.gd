extends Node

class_name PlacementCommand

var friend_name: String
var student : Student
var target_desk: Student  # The empty desk being filled
var grid_position: Vector2i
var state_snapshot: Dictionary
var level: Node

func _init(student_: Student, desk: Student, pos: Vector2i, state_: Dictionary, level_node: Node):
	student = student_
	friend_name = student_.name
	target_desk = desk
	grid_position = pos
	state_snapshot = state_.duplicate(true)
	level = level_node
	
func get_level() -> Node:
	return get_node("/root/Level")

func execute() -> void:
	target_desk.set_student_name(friend_name)
	target_desk.grid_position = grid_position
	level.friend_placement_panel.remove_icon(friend_name)
	level.update_classroom_array(target_desk, friend_name)  # Update array BEFORE applying state
	apply_state_changes(level)  # Then apply state changes
	level.current_note_holder = target_desk
	level.update_preview()

func undo() -> void:
	target_desk.set_student_name("Empty")
	level.update_classroom_array(target_desk, "Empty")
	level.friend_placement_panel.add_icon(friend_name)
	
	var classroom_state = level.classroom.duplicate(true)
	restore_state_from_snapshot(level)
	level.classroom = classroom_state 
	
	# Set note holder
	if level.planner.current_index > 0:
		level.current_note_holder = level.planner.commands[level.planner.current_index - 1].target_desk
	else:
		level.current_note_holder = level.player
	
	level.update_preview()

func apply_state_changes(level):
	# Apply state changes from snapshot
	level.teacher_looking = state_snapshot.teacher_looking
	level.needs_bff = state_snapshot.needs_bff
	level.bff_visited = state_snapshot.bff_visited
	level.current_distractions = state_snapshot.current_distractions.duplicate()
	level.note_properties = state_snapshot.note_properties.duplicate(true)
	level.classroom = state_snapshot.classroom.duplicate(true)
	
func restore_state_from_snapshot(level):
	# Restore state from snapshot
	level.teacher_looking = state_snapshot.teacher_looking
	level.needs_bff = state_snapshot.needs_bff
	level.bff_visited = state_snapshot.bff_visited
	level.current_distractions = state_snapshot.current_distractions.duplicate()
	level.note_properties = state_snapshot.note_properties.duplicate(true)
	level.classroom = state_snapshot.classroom.duplicate(true)
