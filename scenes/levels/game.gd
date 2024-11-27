extends Node2D

var debug_on: bool = Globals.debug_on

var planner: PlanningController
var current_level: int = 1
var level_config: Dictionary
var student_configs : Dictionary
var classroom : Array
var friends : Array
var turn_limit: int = 5

@onready var desk_grid = $UI/Desks/MarginContainer/GridContainer
@onready var student_profile_box = $UI/StudentProfiles
@onready var friend_placement_panel = $UI/FriendPlacementPanel
@onready var note_trail = $UI/NoteTrail

var arrow = load("res://assets/sprites/cursor.png")

@onready var friend_scene : PackedScene = preload("res://scenes/characters/student/friend.tscn")
@onready var rival_scene : PackedScene = preload("res://scenes/characters/student/rival.tscn")
@onready var desk_scene : PackedScene = preload("res://scenes/props/desk.tscn")

# game state vars
var player: Student
var current_note_holder: Student

func _ready():
	# Load the custom images for the mouse cursor
	Input.set_custom_mouse_cursor(arrow)

	# Create planner with reference to this level
	planner = PlanningController.new(self)

	# Load level
	load_level_config()
	setup_level()
	
	# Hide student profile box
	#student_profile_box.hide()
	
func _input(event):
	if event.is_action_pressed("undo"):
		planner.undo()
		update_preview()
	elif event.is_action_pressed("redo"):
		planner.redo()
		update_preview()
	elif event.is_action_pressed("ui_accept"):
		return

func setup_level():
	# Clear placeholder grid
	for child in desk_grid.get_children():
		child.queue_free()

	# Place students
	for row in classroom:
		for student_name in row:
			if student_name:
				seat_student(student_name)
			else:
				print("No student name.")

	# Add friends to Friend Selector
	for friend in friends:
		friend_placement_panel.add_icon(friend)

	# Set up player and note holder
	player = get_tree().get_first_node_in_group("player")
	current_note_holder = player
	
	# Set note trail position
	var player_center = player.get_node("Control/Panel/Marker2D").global_position
	note_trail.position = player_center
	
	# Set character profile to first friend
	_on_student_clicked(friend_placement_panel.get_node("Panel/GridContainer").get_children()[0])

	# init planning phase
	planner.start_planning()

	# Update initial highlights
	update_preview()
	
func load_level_config():
	var level_script = load("res://scenes/levels/level_%d.gd" % current_level).new()
	level_config = level_script.level_config
	student_configs = level_config["student_configs"]
	classroom = level_config.classroom
	friends = level_config.friends

func on_level_complete():
	# Show completion message
	# TODO: await message confirmation
	current_level += 1
	load_level_config()
	reset_and_setup_level()

func reset_and_setup_level():
	# Clear existing students/desks
	for child in desk_grid.get_children():
		child.queue_free()
	# Clear note trail
	note_trail.clear_points()
	# Reset game state
	student_configs = level_config["student_configs"]
	classroom = level_config.classroom
	friends = level_config.friends
	# Setup new layout from config
	setup_level()

func get_current_game_state() -> Dictionary:
	return {
		"classroom": classroom.duplicate(true),
	}
	
func update_preview() -> void:
	
	# Debug prints
	if debug_on:
		print("\n--- Updating Preview ---")
		print("Current index: ", planner.current_index)
		print("Current note holder: ", current_note_holder.name)
		print("Classroom state: ", classroom)
	
	# Calculate and show valid moves - might make this a debug feature later
	#var valid_moves = get_valid_empty_desks(current_note_holder)
	#for valid_desk in valid_moves:
		#valid_desk.highlight(true) # valid = true
		
	
		
	# Update turn count
	print("Turn: ", planner.turn_count+1) 
	#turn_counter.update(planner.turn_count+1)

	# Show note icon for current holder
	current_note_holder.receive_note()

func seat_student(student_name):
	var student: Student
	student = friend_scene.instantiate()
	desk_grid.add_child(student)
	
	# Name student
	student.set_student_name(student_name)
	
	# Highlight
	if student_name == "empty":
		student.is_moveable = true
	else:
		student.is_moveable = false

	
	# Set player status
	if student.name == "player":
		student.make_player()
		student.is_moveable = true
		
	# Set crush as friend    
	elif student.name == "crush":
		student.is_friend = true
		student.is_moveable = true
	else:
		student.is_friend = false

	# Lock movement (characters placed at start of game cannot be moved)
	student.highlight(true)
	
#func get_desk_position(student: Student) -> Vector2i:
	## If it's an empty desk, we need to find the correct empty position
	#if student.name.begins_with("empty"):
		#for row in classroom.size():
			#for col in classroom[row].size():
				## Get the desk index to match with the actual desk we're checking
				#var desk_index = row * classroom[0].size() + col
				#if desk_grid.get_child(desk_index) == student and classroom[row][col] == "empty":
					#return Vector2i(col, row)
	#else:
		## Original logic for named desk_grid
		#for row in classroom.size():
			#for col in classroom[row].size():
				#if classroom[row][col] == student.name:
					#return Vector2i(col, row)
#
	#return Vector2i(-1, -1)
	

	
func check_solution(note_chain) -> bool:
	# Make sure chain starts with player and ends with crush
	if note_chain[0] == player and note_chain[-1].name == "crush":
		print("Note passed to crush!!")
		student_profile_box.set_text("Note passed to crush!!")
		on_level_complete()
		return true
	return false
	
func calculate_note_chain():
	var note_chain = [player]  # Start with player node
	var current_holder = player
	var valid_chain = true
	while valid_chain:
		valid_chain = false  # Reset flag
		# Get current holder's position
		var holder_pos = Utils.get_desk_position(current_holder, classroom, desk_grid)
		var adjacent_positions = Utils.get_adjacent_positions(holder_pos, classroom)
		# Check each adjacent position
		for pos in adjacent_positions:
			var desk_index = pos.y * classroom[0].size() + pos.x
			var adjacent_student = desk_grid.get_child(desk_index)
			# Skip if: empty desk, already in chain, or invalid (highlighted red)
			if adjacent_student.name.begins_with("empty") or \
				not adjacent_student.is_friend or \
				note_chain.has(adjacent_student) or \
				not adjacent_student.placement_valid:
				continue
			
			# Check sequence rules before adding to chain
			if level_config["student_configs"].has(adjacent_student.name):
				var student_config = level_config["student_configs"][adjacent_student.name]
				if student_config.has("rules"):
					var sequence_valid = true
					for rule in student_config.rules:
						if rule is SequenceRule:
							print("Found sequence rule for: ", adjacent_student.name)
							var temp_chain = note_chain.duplicate()
							temp_chain.append(adjacent_student)
							var result = rule.check_valid(adjacent_student, temp_chain, classroom, desk_grid)
							print("Sequence rule check result: ", result)
							if not result.valid:
								sequence_valid = false
								print("Failed sequence rule check")
								adjacent_student.highlight(false)
								break
					if not sequence_valid:
						continue  # Skip this student if they break sequence rules

			# Valid next note holder found
			current_holder = adjacent_student
			note_chain.append(adjacent_student)
			valid_chain = true  # Continue the chain
			break
			
	# Update Note Trail
	note_trail.clear_points() # clear existing points
	for student in note_chain:
		note_trail.add_point(student.position)
				
	# Set current note holder to last student in chain
	current_note_holder = note_chain[-1]
	print("Current note chain: ", note_chain)
	
	check_solution(note_chain)
	
func validate_all_students() -> bool:
	var all_valid = true
	for desk in desk_grid.get_children():
		# Skip empty desks or unplaceable students (not friends)
		if desk.name.begins_with("empty") or !desk.is_friend:
			continue

		# Check student adjacent rules
		var student_valid = true
		if level_config["student_configs"].has(desk.name):
			var student_config = level_config["student_configs"][desk.name]
			if student_config.has("rules"):
				for rule in student_config.rules:
					if rule is AdjacentRule:
						var result = rule.check_valid(desk, desk, classroom, desk_grid)
						if not result.valid:
							student_valid = false
							all_valid = false
							break

		# Update highlight based on validation result
		desk.highlight(student_valid)

	return all_valid

func is_valid_placement(student: Student, target_desk: Student):
	
	var valid = true
	
	# Check if it's empty
	if not target_desk.name.begins_with("empty"):
		print("Desk not empty")
		valid = true
		return valid
	
	# Bypass check if it's player or crush
	if student.name == "player" or student.name == "crush":
		valid = true
		return valid

	# Check adjacency to current note holder
	#if not are_desks_adjacent(current_note_holder, target_desk):
		#print("Not adjacent to note holder")
		#return false
		
	# Check rules - is this redundant if we're calling "validate_all_students"?
	if level_config["student_configs"].has(student.name):
		var student_config = level_config["student_configs"][student.name]
		if student_config.has("rules"):
			for rule in student_config.rules:
				if rule is AdjacentRule:
					var result = rule.check_valid(student, target_desk, classroom, desk_grid)
					print("Rule check result: ", result)
					if not result.valid:
						print("Highlighting student: ", student)
						#target_desk.highlight(false)
						valid = false
	
	return valid

func get_valid_empty_desks(student: Student) -> Array:
	var valid_desks = []
	for row in classroom.size():
		for col in classroom[row].size():
			var desk_content = classroom[row][col]
			if desk_content == "empty":
				var desk_index = row * classroom[0].size() + col
				var empty_desk = desk_grid.get_child(desk_index)
				if is_valid_placement(student, empty_desk):
					valid_desks.append(empty_desk)
	return valid_desks
	
func update_classroom_array(desk: Student, student_name: String):
	var desk_pos = Utils.get_desk_position(desk, classroom, desk_grid)
	classroom[desk_pos.y][desk_pos.x] = student_name
	print(classroom)

func _on_student_clicked(student: Student):
	
	# Show profile for existing desk_grid
	if not student.name.begins_with("empty") and not student.name == "player":
		Globals.selected_student = student
		var student_profile = level_config["student_configs"][student.name]
		student_profile_box.set_text(student_profile)
		student_profile_box.show()
	# Handle empty desk selection
	#else:
		#var valid_desks = get_valid_empty_desks(current_note_holder)
		#if valid_desks.has(student):
			#friend_placement_panel.show()  # Show friend selection UI for valid empty desk

func _on_student_placed(student: Student, desk: Student):
	if student.is_moveable == false:
		return
	# Return on turn limit
	if planner.turn_count+1 >= turn_limit:
		print("Exceeded turn limit of, ",turn_limit ," turns.")
		return

	if planner.add_placement(student, desk):
		#friends.erase(friend_name)  # Remove from available friends
		friend_placement_panel.remove_icon(student.name)
		update_preview()
	else:
		print("Can't place student there!")

#func highlight_valid_recipients(valid_recipients: Array):
	## Add visual feedback for valid recipients
	#for student_name in valid_recipients:
		#var student = desk_grid.get_node(student_name)
		## Add highlight effect
		#student.highlight()

#func clear_highlights():
	## Remove all highlight effects
	#for student in desk_grid.get_children():
		#student.unhighlight()

func _on_undo_pressed():
	planner.undo()

func _on_redo_pressed():
	planner.redo()
