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

func add_move(from_: Student, to_: Student) -> bool:
	# Validate move
	if not is_valid_move(from_, to_):
		return false

   # If we're not at the end, clear future moves
	if current_index < commands.size() - 1:
		commands.resize(current_index + 1)

   # Create and store new command
	var state = level.get_current_game_state()
	var new_command = MoveCommand.new(from_, to_, state, level)
	commands.push_back(new_command)
	current_index += 1
	turn_count += 1
   
   # Execute the preview
	new_command.execute()
	return true

func undo() -> bool:
	if current_index >= 0:
		commands[current_index].undo()
		current_index -= 1
		turn_count -= 1  # Increment turn count
		return true
	return false

func redo() -> bool:
	if current_index < commands.size() - 1:
		current_index += 1
		turn_count += 1  # Increment turn count
		commands[current_index].execute()
		return true
	return false

func is_valid_move(from_: Student, to_: Student) -> bool:
   # Check basic movement validity (adjacency)
	if not level.are_desks_adjacent(from_, to_):
		print("Not adjacent")
		return false
   
   # Check trait-based validity
	var student_traits = from_.student_traits  # Assuming traits array in Student
	for student_trait in student_traits:
		if not check_trait_validity(student_trait, from_, to_):
			return false
   
   # Check state-based validity
	var preview_state = level.get_current_game_state()  # Get current state for preview
	if not check_state_requirements(preview_state, from_, to_):
		return false
		   
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

func get_valid_recipients(from_student: Student) -> Array:
	var valid_recipients = []
	var potential_recipients = level.get_valid_recipients(from_student)

	# Filter based on traits and state
	for recipient in potential_recipients:
		if is_valid_move(from_student, recipient):
			valid_recipients.append(recipient)
		   
	return valid_recipients

func commit_plan() -> void:
	# Execute all commands for real
	for cmd in commands:
		cmd.execute()
