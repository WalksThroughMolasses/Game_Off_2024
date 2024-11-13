extends Node2D

var arrow = load("res://assets/sprites/cursor.png")

var planner: PlanningController

var turn_limit : int = 5

@onready var students = $Desks/MarginContainer/GridContainer
#@onready var characters = $Characters
@onready var turn_counter = $UI/HBoxContainer/TurnCounter
@onready var student_profile_box = $UI/StudentProfiles
@onready var student_scene : PackedScene = preload("res://scenes/characters/student/student.tscn")
@onready var desk_scene : PackedScene = preload("res://scenes/props/desk.tscn")

var classroom = [
	["Player", "Alex", null, null],
	["Bella", "Lucia", "Diego", null],
	[null, "Priya", "Oliver", null],
	[null, null, null, null]
]

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
var selected_student: Student

func get_current_game_state() -> Dictionary:
	return {
		"teacher_looking": teacher_looking,
		"needs_bff": needs_bff,
		"bff_visited": bff_visited,
		"current_distractions": current_distractions.duplicate(),
		"note_properties": note_properties.duplicate(true),
		#"student_states": get_student_states()
	}

func _ready():
	# Load the custom images for the mouse cursor.
	Input.set_custom_mouse_cursor(arrow)
	
	# Create planner with reference to this level
	planner = PlanningController.new(self)
	
	# hide student profile box
	student_profile_box.hide()
	
	# clear placeholder grid
	for child in students.get_children():
		child.free()
	
	var desk_index = 0
	for row in classroom:
		for student_name in row:
			if student_name:
				seat_student(desk_index, student_name)
			else:
				add_empty_desk(desk_index)
			desk_index += 1
	
	player = get_tree().get_first_node_in_group("player")
	current_note_holder = player
	print(current_note_holder)
			
	# init planning phase
	planner.start_planning()
	
	# Update initial highlights
	update_preview()
	
func update_preview() -> void:
	# Update who has the note based on current plan
	if planner.current_index >= 0:
		var last_move = planner.commands[planner.current_index]
		current_note_holder = last_move.to_student
	else:
		# If we've undone back to start
		current_note_holder = students.get_node("Player")

	# Clear any highlights from all students
	for child in students.get_children():
		if child is Student:
			child.passed_note()
			child.unhighlight()

	# Show note icon for current holder
	current_note_holder.receive_note()

	# Maybe also highlight valid moves from current position
	var valid_moves = planner.get_valid_recipients(current_note_holder)
	for valid_student in valid_moves:
		valid_student.highlight()
	
	# Update turn count
	#turn_count.text = str(planner.turn_count)
	print("Turn: ", planner.turn_count+1) 
	turn_counter.update(planner.turn_count+1) # convert 0 indexed to a counter starting from 1
	
func add_empty_desk(desk_index):
	var empty_desk = desk_scene.instantiate()
	
	students.add_child(empty_desk)

func seat_student(desk_index, student_name):
	var student = student_scene.instantiate()
	
	students.add_child(student)
	#student.position = desk.get_screen_position()
	
	# name student
	student.name = student_name
	student.set_student_name(student.name)
	
	# set player status
	if student.name == "Player":
		student.make_player()
	
func get_student_position(student: Student) -> Vector2i:
	for row in classroom.size():
		for col in classroom[row].size():
			if student:
				var student_name = student.name
				if classroom[row][col] == student_name:
					return Vector2i(col, row)
	return Vector2i(-1, -1)  # Return invalid position if not found

func are_desks_adjacent(student1: Student, student2: Student) -> bool:
	var pos1 = get_student_position(student1)
	var pos2 = get_student_position(student2)
	
	# Check if same row and adjacent column
	if pos1.y == pos2.y:
		return abs(pos1.x - pos2.x) == 1
		
	# Check if same column and adjacent row
	if pos1.x == pos2.x:
		return abs(pos1.y - pos2.y) == 1
		
	return false
	
func get_valid_recipients(from_student: Student) -> Array:
	var valid_recipients = []
	
	for row in classroom.size():
		for col in classroom[row].size():
			var student_name = classroom[row][col]
			if student_name != null and student_name != from_student.name:
				if are_desks_adjacent(from_student, students.get_node(student_name)):
					valid_recipients.append(students.get_node(student_name))

	return valid_recipients

func _on_student_clicked(student: Student):
	# TODO: change this to profile highlighting
	# Can only pass from current note holder
	selected_student = student
	student_profile_box.set_text(selected_student.name)
	student_profile_box.show()

	#if planner.is_valid_move(current_note_holder, student):
		#planner.add_move(current_note_holder, student)
		#update_preview()
	#else:
		#print("Can't pass note there!")

func _on_confirm_pass_note_clicked():
	# Return on turn limit
	if planner.turn_count+1 >= turn_limit:
		print("Exceeded turn limit of, ",turn_limit ," turns.")
		return
	
	# Can only pass from current note holder
	if planner.is_valid_move(current_note_holder, selected_student):
		planner.add_move(current_note_holder, selected_student)
		update_preview()
	else:
		print("Can't pass note there!")

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
		_on_confirm_pass_note_clicked()

func _on_undo_pressed():
	planner.undo()
	update_preview()

func _on_redo_pressed():
	planner.redo()
	update_preview()
