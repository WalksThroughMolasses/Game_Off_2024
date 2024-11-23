# planning_controller.gd
extends Node
class_name PlanningController

var level: Node  # Reference to level node
var commands: Array = []  # Stack of move commands
var turn_count: int = 0 
var current_index: int = -1
var initial_state: Dictionary

func _init(level_node: Node):
	level = level_node

func start_planning() -> void:
	initial_state = level.get_current_game_state()
	current_index = -1
	commands.clear()
	turn_count = 0

func add_placement(student: Student, target_desk: Student) -> bool:
	# Validate placement
	var valid = level.is_valid_placement(student, target_desk)

	# This clears all future moves when re-placing students after undo
	if current_index < commands.size() - 1:
		commands.resize(current_index + 1)
	
	var grid_pos = target_desk.grid_position
	
	level.update_classroom_array(target_desk, student.name)

	# Create and store new command
	var state = level.get_current_game_state()
	var new_command = PlacementCommand.new(student, target_desk, grid_pos, state, level, valid)
	commands.push_back(new_command)
	current_index += 1
	turn_count += 1

	# Execute the preview
	new_command.execute()
	return true

func undo() -> bool:
	if current_index >= 0:
		# Get the state from before this move
		var previous_state
		if current_index > 0:
			previous_state = commands[current_index - 1].state_snapshot
		else:
			previous_state = initial_state
			level.current_note_holder = level.player  # Reset to player

		commands[current_index].undo()
		current_index -= 1
		turn_count -= 1
		
		level.classroom = previous_state.classroom.duplicate(true)
		
		return true
	return false

func redo() -> bool:
	if current_index < commands.size() - 1:
		current_index += 1
		turn_count += 1
		commands[current_index].execute()
		
		# Set current note holder
		#level.current_note_holder = commands[current_index].target_desk
		return true
	return false
		
func commit_plan() -> void:
	# Execute all commands for real
	for cmd in commands:
		cmd.execute()
