extends Node
class_name MoveCommand

var from_student: Student  # Who has the note
var to_student: Student   # Who they're passing to
var state_snapshot: Dictionary
var level: Node

func _init(from_: Student, to_: Student, state_: Dictionary, level_node: Node):
	from_student = from_
	to_student = to_
	state_snapshot = state_.duplicate(true)
	level = level_node  # Store level reference
	
func get_level() -> Node:
	return get_node("/root/Level")

func execute() -> void:
	level.current_note_holder = to_student
	apply_state_changes(level)

func undo() -> void:
	level.current_note_holder = from_student
	restore_state_from_snapshot(level)
	
func apply_state_changes(level):
	# Apply state changes from snapshot
	level.teacher_looking = state_snapshot.teacher_looking
	level.needs_bff = state_snapshot.needs_bff
	level.bff_visited = state_snapshot.bff_visited
	level.current_distractions = state_snapshot.current_distractions.duplicate()
	level.note_properties = state_snapshot.note_properties.duplicate(true)

func restore_state_from_snapshot(level):
	# Restore state from snapshot
	level.teacher_looking = state_snapshot.teacher_looking
	level.needs_bff = state_snapshot.needs_bff
	level.bff_visited = state_snapshot.bff_visited
	level.current_distractions = state_snapshot.current_distractions.duplicate()
	level.note_properties = state_snapshot.note_properties.duplicate(true)
