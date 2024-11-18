extends Node2D

var arrow = load("res://assets/sprites/cursor.png")

var planner: PlanningController

var turn_limit : int = 5

@onready var students = $Desks/MarginContainer/GridContainer
#@onready var characters = $Characters
@onready var turn_counter = $UI/HBoxContainer/TurnCounter
@onready var student_profile_box = $UI/StudentProfiles
@onready var friend_placement_panel = $UI/FriendPlacementPanel

@onready var friend_scene : PackedScene = preload("res://scenes/characters/student/friend.tscn")
@onready var rival_scene : PackedScene = preload("res://scenes/characters/student/rival.tscn")
@onready var desk_scene : PackedScene = preload("res://scenes/props/desk.tscn")

var classroom = [
	["Player", "Empty", "Rival", "Empty"],
	["Empty", "Rival", "Rival", "Empty"],
	["Empty", "Empty", "Empty", "Empty"],
	["Empty", "Empty", "Rival", "Crush"]
]
var friends = ["Origami", "Hoops", "Twin 1"]

# game state vars
var teacher_looking: bool = false
var needs_bff: bool = true
var bff_visited: bool = false
var current_distractions: Array = []
var note_properties: Dictionary = {
	"is_doodled": false,
	"is_invisible": false,
	"can_origami": true
}
var player: Student
var current_note_holder: Student

func get_current_game_state() -> Dictionary:
	return {
		"teacher_looking": teacher_looking,
		"needs_bff": needs_bff,
		"bff_visited": bff_visited,
		"current_distractions": current_distractions.duplicate(),
		"note_properties": note_properties.duplicate(true),
		"classroom": classroom.duplicate(true),
	}

func _ready():
	# Load the custom images for the mouse cursor.
	Input.set_custom_mouse_cursor(arrow)
	
	# Create planner with reference to this level
	planner = PlanningController.new(self)
	
	# Hide student profile box
	#student_profile_box.hide()
	
	# Clear placeholder grid
	for child in students.get_children():
		child.free()
	
	var desk_index = 0
	for row in classroom:
		for student_name in row:
			if student_name:
				if student_name:
					seat_student(desk_index, student_name)
			else:
				add_empty_desk(desk_index)
			desk_index += 1
			
	# Add friends to Friend Selector
	for friend in friends:
		friend_placement_panel.add_icon(friend)
	
	player = get_tree().get_first_node_in_group("player")
	current_note_holder = player
	print(current_note_holder)
			
	# init planning phase
	planner.start_planning()
	
	# Update initial highlights
	update_preview()
	
func update_preview() -> void:
	# Clear any highlights from all desks
	for child in students.get_children():
		if child is Student:
			#child.passed_note()
			child.unhighlight()
	
	# Debug prints
	print("\n--- Updating Preview ---")
	print("Current index: ", planner.current_index)
	print("Current note holder: ", current_note_holder.name)
	print("Classroom state: ", classroom)
	
	# Calculate and show valid moves
	var valid_moves = get_valid_empty_desks(current_note_holder)
	for valid_desk in valid_moves:
		valid_desk.highlight()
		
	# Update turn count
	print("Turn: ", planner.turn_count+1) 
	turn_counter.update(planner.turn_count+1)

	# Show note icon for current holder
	current_note_holder.receive_note()

func add_empty_desk(desk_index):
	var empty_desk = desk_scene.instantiate()
	
	students.add_child(empty_desk)

func seat_student(desk_index, student_name):
	var student: Student
	if student_name == "Rival":
		student = rival_scene.instantiate()
	else:
		student = friend_scene.instantiate()
	
	students.add_child(student)
	#student.position = desk.get_screen_position()
	
	# Name student
	student.name = student_name
	student.set_student_name(student.name)
	
	# Set player status
	if student.name == "Player":
		student.make_player()
	
	# Lock movement (characters placed at start of game cannot be moved)
	student.is_moveable = false
	
func get_desk_position(student: Student) -> Vector2i:
	# If it's an empty desk, we need to find the correct empty position
	if student.name.begins_with("Empty"):
		for row in classroom.size():
			for col in classroom[row].size():
				# Get the desk index to match with the actual desk we're checking
				var desk_index = row * classroom[0].size() + col
				if students.get_child(desk_index) == student and classroom[row][col] == "Empty":
					return Vector2i(col, row)
	else:
		# Original logic for named students
		for row in classroom.size():
			for col in classroom[row].size():
				if classroom[row][col] == student.name:
					return Vector2i(col, row)

	return Vector2i(-1, -1)
	
func can_bounce_to(note_holder, target_desk):
	pass

func can_throw_to(note_holder, target_desk):
	pass
	
func can_twin_swap(note_holder, target_desk):
	pass

func is_desk_valid(note_holder: Student, target_desk: Student):
	# Check if it's empty
	if not target_desk.name.begins_with("Empty"):
		return false

	# Check basic adjacency
	if are_desks_adjacent(note_holder, target_desk):
		return true

	# Then check special movements based on traits
	if note_holder.has_trait("Hoops"):
		return can_bounce_to(note_holder, target_desk)
	elif note_holder.has_trait("Origami"):
		return can_throw_to(note_holder, target_desk)
	elif note_holder.has_trait("Twin"):
		return can_twin_swap(note_holder, target_desk)

	return false
	
func are_desks_adjacent(note_holder: Student, empty_desk: Student) -> bool:
	var pos1 = get_desk_position(note_holder)
	var pos2 = get_desk_position(empty_desk)

	#print("\nChecking adjacency:")
	#print("Position 1 (note holder): ", pos1)
	#print("Position 2 (empty desk): ", pos2)

	# Check if same row and adjacent column
	if pos1.y == pos2.y:
		return abs(pos1.x - pos2.x) == 1

	# Check if same column and adjacent row
	if pos1.x == pos2.x:
		return abs(pos1.y - pos2.y) == 1

	return false
	
func get_valid_empty_desks(student: Student) -> Array:
	var valid_desks = []

	#print("\n--- Checking Valid Desks ---")
	#print("Note holder: ", student.name)
	var note_holder_pos = get_desk_position(student)
	#print("Note holder position: ", note_holder_pos)
	
	for row in classroom.size():
		for col in classroom[row].size():
			var desk_content = classroom[row][col]
			print("Checking [%d,%d]: %s" % [row, col, desk_content])
			if desk_content == "Empty":
				var desk_index = row * classroom[0].size() + col
				var empty_desk = students.get_child(desk_index)
				var empty_desk_pos = get_desk_position(empty_desk)
				print("Found empty at [%d,%d], desk name: %s" % [row, col, empty_desk.name])

				var is_same_row = note_holder_pos.y == empty_desk_pos.y
				var is_same_col = note_holder_pos.x == empty_desk_pos.x
				var row_diff = abs(note_holder_pos.y - empty_desk_pos.y)
				var col_diff = abs(note_holder_pos.x - empty_desk_pos.x)

				#print("Same row: ", is_same_row, " Row diff: ", row_diff)
				#print("Same col: ", is_same_col, " Col diff: ", col_diff)

				var is_valid = is_desk_valid(student, empty_desk)
				#print("Is adjacent: ", is_adjacent)

				if is_valid:
					valid_desks.append(empty_desk)
	
	#print("\nFound ", valid_desks.size(), " valid desks")
	return valid_desks
	
func update_classroom_array(desk: Student, student_name: String):
	var desk_pos = get_desk_position(desk)
	classroom[desk_pos.y][desk_pos.x] = student_name
	print(classroom)

func _on_student_clicked(student: Student):
	# Show profile for existing students
	if not student.name.begins_with("Empty"):
		Globals.selected_student = student
		student_profile_box.set_text(Globals.selected_student.name)
		student_profile_box.show()
	# Handle empty desk selection
	else:
		var valid_desks = get_valid_empty_desks(current_note_holder)
		if valid_desks.has(student):
			friend_placement_panel.show()  # Show friend selection UI for valid empty desk

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

func highlight_valid_recipients(valid_recipients: Array):
	# Add visual feedback for valid recipients
	for student_name in valid_recipients:
		var student_node = students.get_node(student_name)
		# Add highlight effect
		student_node.highlight()

func clear_highlights():
	# Remove all highlight effects
	for student in students.get_children():
		student.unhighlight()

func _input(event):
	if event.is_action_pressed("undo"):
		planner.undo()
		update_preview()
	elif event.is_action_pressed("redo"):
		planner.redo()
		update_preview()
	elif event.is_action_pressed("ui_accept"):
		return
		#_on_student_placed()

func _on_undo_pressed():
	planner.undo()

func _on_redo_pressed():
	planner.redo()
