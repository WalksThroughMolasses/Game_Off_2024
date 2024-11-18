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
	if not is_valid_placement(student, target_desk):
		return false

	# If we're not at the end, clear future moves
	if current_index < commands.size() - 1:
		commands.resize(current_index + 1)
	
	var grid_pos = target_desk.grid_position
	
	level.update_classroom_array(target_desk, student.name)

	# Create and store new command
	var state = level.get_current_game_state()
	var new_command = PlacementCommand.new(student, target_desk, grid_pos, state, level)
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

func is_valid_placement(student: Student, target_desk: Student) -> bool:
	# Check if desk is empty
	if not target_desk.name.begins_with("Empty"):
		return false
		
	# Check if desk is adjacent to current_note_holder
	if not level.are_desks_adjacent(level.current_note_holder, target_desk):
		return false
		
	# Add any other placement validation logic

	return true

func check_trait_validity(student_trait: String, from_: Student, to_: Student) -> bool:
	match student_trait:
		"Twin":
			return check_twin_validity(from_, to_)
		"BFF":
			return check_bff_validity(from_, to_)
		"Smooth":
			return check_smooth_validity(from_, to_)
		_:
			return true

func check_twin_validity(from_: Student, to_: Student) -> bool:
   # For now, just allow the move
   # Later: check if this would create an infinite loop
	return true

func check_bff_validity(from_: Student, to_: Student) -> bool:
   # For now, just allow the move
   # Later: implement BFF requirements
	return true

func check_smooth_validity(from_: Student, to_: Student) -> bool:
   # Smooth students can pass even when teacher is looking
	return true

func check_state_requirements(state: Dictionary, from_: Student, to_: Student) -> bool:
   # Check teacher looking state
	if state.teacher_looking and not from_.has_trait("Smooth"):
		return false
   
   # Check BFF requirement
	#if state.needs_bff and not bff_visited:
	## Later: implement check if BFF can still be reatched
		#pass
	   
	return true

#func get_valid_recipients(from_student: Student) -> Array:
	#var valid_recipients = []
	#var potential_recipients = level.get_valid_recipients(from_student)
#
	## Filter based on traits and state
	#for recipient in potential_recipients:
		#if is_valid_move(from_student, recipient):
			#valid_recipients.append(recipient)
		   #
	#return valid_recipients

func commit_plan() -> void:
	# Execute all commands for real
	for cmd in commands:
		cmd.execute()
