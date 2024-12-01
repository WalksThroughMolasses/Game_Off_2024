extends Node2D

var debug_on: bool = Globals.debug_on

var level_config: Dictionary
var student_configs : Dictionary
var classroom : Array
var friends : Array
var awaiting_level_advance : bool = false

@onready var desk_grid = $UI/Desks/MarginContainer/GridContainer
@onready var student_profile_box = $UI/StudentProfiles
@onready var friend_placement_panel = $UI/FriendPlacementPanel
@onready var note_trail = $UI/NoteTrail
@onready var note_screen = $UI/Note
@onready var start_menu = $UI/StartMenu

@onready var friend_scene : PackedScene = preload("res://scenes/characters/student/friend.tscn")
@onready var rival_scene : PackedScene = preload("res://scenes/characters/student/rival.tscn")
@onready var desk_scene : PackedScene = preload("res://scenes/props/desk.tscn")


# game state vars
var player: Student
var current_note_holder: Student

func _ready():
	# Load the custom images for the mouse cursor
	Input.set_custom_mouse_cursor(Globals.cursor, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(Globals.cursor, Input.CURSOR_FORBIDDEN)
	
	start_menu.show()
	
func _input(event):
	
	if awaiting_level_advance:
		return
	
	if event.is_action_pressed("click"):
		Input.set_custom_mouse_cursor(Globals.cursor_small, Input.CURSOR_ARROW)
		Input.set_custom_mouse_cursor(Globals.cursor_small, Input.CURSOR_FORBIDDEN)
		#AudioController.play_sfx("click")
	
	if event.is_action_released("click"):
		Globals.selected_student = null
		Input.set_custom_mouse_cursor(Globals.cursor, Input.CURSOR_ARROW)
		Input.set_custom_mouse_cursor(Globals.cursor, Input.CURSOR_FORBIDDEN)

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
	
	# Set character profile to player
	_on_student_clicked(player)
	player.grab_focus()

	# Display note
	print("Displaying next note.")
	note_screen.display_next_note()

	# Update initial highlights
	update_preview()
	
func load_end_screen():
	Globals.game_over = true
	note_screen.display_next_note()
	
func load_level_config():
	print(Globals.current_level)
	var level_script = load("res://scenes/levels/level_%d.gd" % Globals.current_level).new()
	level_config = level_script.level_config
	student_configs = level_config["student_configs"]
	classroom = level_config.classroom
	friends = level_config.friends

func on_level_complete(note_chain):
	# Show completion message
	print("Level Complete!")
	awaiting_level_advance = true
	await play_note_passing_animation(note_chain)
	await get_tree().create_timer(0.1).timeout  # Small buffer to ensure animation started
	
	Globals.current_level += 1
	if Globals.current_level <= 6:
		load_level_config()
		reset_and_setup_level()
	elif Globals.current_level == 7:
		load_end_screen()

func restart_game():
	Globals.current_level = 1
	Globals.game_over = false
	get_tree().reload_current_scene()
	
func reset_and_setup_level():
	# Reset current note holder and player references
	current_note_holder = null
	player = null

	# Clear existing students/desks
	for child in desk_grid.get_children():
		child.queue_free()
	
	# Clear friend placement panel icons
	friend_placement_panel.clear_all_icons()

	# Important: Wait for the next frame to ensure nodes are fully freed
	await get_tree().process_frame

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
		print("Current note holder: ", current_note_holder.name)
		print("Classroom state: ", classroom)

	current_note_holder.receive_note()

func seat_student(student_name):
	var student: Student
	student = friend_scene.instantiate()
	desk_grid.add_child(student)
	
	# Name student
	student.set_student_name(student_name)
	student.highlight(true)

func find_valid_path() -> Array:
	var to_visit = [[player]]  # Array of paths (each path is an array of students)
	var visited = {}
	
	while to_visit:
		var current_path = to_visit.pop_front()
		var current = current_path[-1]  # Get last student in current path
		
		if current in visited:
			continue
			
		visited[current] = true

		# If we reached the crush, return this path
		if current.is_in_group("crush"):
			return current_path
			
		# Get all adjacent students
		var current_pos = Utils.get_desk_position(current, classroom, desk_grid)
		var adjacent_positions = Utils.get_adjacent_positions(current_pos, classroom)

		# Check each adjacent student
		for pos in adjacent_positions:
			var desk_index = pos.y * classroom[0].size() + pos.x
			var adjacent_student = desk_grid.get_child(desk_index)

			# Add path to visit if it's a valid student we haven't checked
			if not adjacent_student.name.begins_with("empty") and \
				adjacent_student.is_friend and \
				not visited.has(adjacent_student):
				var new_path = current_path.duplicate()
				new_path.append(adjacent_student)
				to_visit.push_back(new_path)
	
	return []
	
func play_note_passing_animation(note_chain: Array, delay: float = 0.2):
	
	var notes = AudioController.get_notes_for_chain(note_chain.size())
	
	# Disable moving students
	for desk in desk_grid.get_children():
		desk.is_moveable = false
	
	var note_animation = note_trail.get_node("Animation")
	var tween: Tween

	note_animation.show()

	for i in range(note_chain.size()):
		var current_student = note_chain[i]
		note_animation.position = current_student.position
		await get_tree().create_timer(delay).timeout
		AudioController.play_music(notes[i])
		await current_student.shake(0.2, 3.0)

		# If there's a next student, tween to their position
		if i < note_chain.size() - 1:
			var next_student = note_chain[i + 1]
			# Kill previous tween if it exists
			if tween:
				tween.kill()
				
			# Calculate movement direction and set rotation
			var movement = next_student.position - current_student.position
			var is_vertical = abs(movement.y) > abs(movement.x)
			
			# Create rotation tween
			var rotation_tween = create_tween()
			var target_rotation = 90.0 if is_vertical else 0.0
			rotation_tween.tween_property(note_animation, "rotation_degrees", target_rotation, delay/2).set_ease(Tween.EASE_IN_OUT)
			
			# Create movement tween
			tween = create_tween()
			tween.tween_property(note_animation, "position", next_student.position, delay).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
			await tween.finished

	var crush = get_tree().get_first_node_in_group("crush")
	crush.heartbeat_animation()
	AudioController.play_school_bell()
	await get_tree().create_timer(3).timeout
	
	awaiting_level_advance = false

func check_solution(note_chain) -> bool:
	# Check if there are still unplaced students
	if friend_placement_panel.get_node("Panel/GridContainer").get_child_count() > 0:
		return false
		
	# Check if all placed students are valid
	for desk in desk_grid.get_children():
		if not desk.name.begins_with("empty") and not desk.placement_valid:
			return false
	 
	var valid_path = find_valid_path()
	if valid_path:
		note_chain = valid_path  # Set the note chain to this path
		# Update note trail with new path
		note_trail.clear_points()
		for student in note_chain:
			note_trail.add_point(student.position)
		current_note_holder = note_chain[-1]
		print(note_chain)
		print("Valid path to crush found!")
		#student_profile_box.set_text("Note passed to crush!!", "")
		on_level_complete(note_chain)
		return true
	return false
	
func calculate_note_chain():
	note_trail.clear_points()
	var note_chain = [player]
	var current_holder = player
	var valid_chain = true

	while valid_chain:
		valid_chain = false
		var holder_pos = Utils.get_desk_position(current_holder, classroom, desk_grid)
		var adjacent_positions = Utils.get_adjacent_positions(holder_pos, classroom)

		for pos in adjacent_positions:
			var desk_index = pos.y * classroom[0].size() + pos.x
			var adjacent_student = desk_grid.get_child(desk_index)

			if adjacent_student.name.begins_with("empty") or \
				not adjacent_student.is_friend or \
				note_chain.has(adjacent_student) or \
				not adjacent_student.placement_valid:
				continue

			# Check sequence rules
			if student_configs.has(adjacent_student.name):
				var student_config = student_configs[adjacent_student.name]
				if student_config.has("rules"):
					var sequence_valid = true
					for rule in student_config.rules:
						if rule is SequenceRule:
							var temp_chain = note_chain.duplicate()
							temp_chain.append(adjacent_student)
							var result = rule.check_valid(adjacent_student, temp_chain, classroom, desk_grid, student_configs)
							if not result.valid:
								sequence_valid = false
								adjacent_student.invalid_reason = result.reason
								adjacent_student.highlight(false)
								break
					if not sequence_valid:
						continue

			# Valid next note holder found
			current_holder = adjacent_student
			note_chain.append(adjacent_student)
			valid_chain = true
			break

	# Update Note Trail
	for student in note_chain:
		note_trail.add_point(student.position)

	current_note_holder = note_chain[-1]
	return check_solution(note_chain)
	
func check_adjacent_rules(student: Student, desk: Student) -> Dictionary:
   # Skip for special students
	if student.name == "player" or student.name == "crush":
		return {"valid": true}

   # Check adjacent rules
	if student_configs.has(student.name):
		var student_config = student_configs[student.name]
		if student_config.has("rules"):
			for rule in student_config.rules:
				if rule is AdjacentRule:
					var result = rule.check_valid(student, desk, classroom, desk_grid, student_configs)
					if not result.valid:
						return result				
	return {"valid": true}

func is_valid_placement(student: Student, target_desk: Student) -> bool:
	var result = check_adjacent_rules(student, target_desk)
	if not result.valid:
		student.invalid_reason = result.reason
		if student is Avatar:
			student.highlight(false)
	return result.valid

func validate_all_students() -> bool:
	var all_valid = true
	for desk in desk_grid.get_children():
		if desk.name.begins_with("empty") or !desk.is_friend:
			continue
		   
		var result = check_adjacent_rules(desk, desk)
		desk.invalid_reason = result.get("reason", "")
		desk.highlight(result.valid)
		if not result.valid:
			all_valid = false
	return all_valid

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
	classroom[desk_pos.y][desk_pos.x] = String(student_name)

func _on_student_clicked(student: Student):
	# Show profile for existing desk_grid
	if not student.name.begins_with("empty"): # and not "player" in student.name
		var student_profile = level_config["student_configs"][student.name]
		student_profile_box.set_text(student_profile, student.invalid_reason)
		
		print(student_profile)

func _on_student_placed(student: Student, target_desk: Student) -> void:
	print("Student being placed: ", student)
	var student_name = student.name
	var valid = is_valid_placement(student, target_desk)
	#var grid_pos = target_desk.grid_position
	
	if student is Icon:
		# icon has been placed in classroom
		friend_placement_panel.remove_icon(student.name)
	elif student is Avatar:
		var current_pos = Utils.get_desk_position(student, classroom, desk_grid)
		# student has been placed back in the placement panel
		if current_pos != Vector2i(-1, -1):
			classroom[current_pos.y][current_pos.x] = "empty"
		student.set_desk_empty()
	
	# Update classroom array
	var new_pos = Utils.get_desk_position(target_desk, classroom, desk_grid)
	classroom[new_pos.y][new_pos.x] = String(student_name)
	
	# Update target desk
	target_desk.highlight(valid)
	target_desk.set_student_name(student_name)
	target_desk.empty_desk = false
	target_desk.grab_focus()

	current_note_holder = target_desk
	
	# Play sound
	AudioController.play_sfx("place")

	# Update game state
	validate_all_students()
	calculate_note_chain()
	update_preview()
	
	# Update character profile with validity check feedback - we do this after all rule check validation
	if target_desk.empty_desk == false:
		var student_profile = level_config["student_configs"][target_desk.name]
		student_profile_box.set_text(student_profile, target_desk.invalid_reason)
		
func _on_student_dragged(student: Student):
	# what's the target desk?
	
	print("dragging student: ", student)
	
func _on_student_return_to_panel(student: Student):
	# Clear their position in the classroom array
	var pos = Utils.get_desk_position(student, classroom, desk_grid)
	if pos != Vector2i(-1, -1):
		classroom[pos.y][pos.x] = "empty"
	
	var friend_list = friend_placement_panel.grid_container.get_children()
	var student_node = friend_list.filter(func(node): return node.name == student.name)
	
	if not student_node.is_empty():
		student_node[0].character_art.modulate.a = 1
	else:
		friend_placement_panel.add_icon(student.name)
		student.set_desk_empty()
	
	# Play SFX
	AudioController.play_sfx("place")
		
	validate_all_students()
	calculate_note_chain()
	update_preview()
