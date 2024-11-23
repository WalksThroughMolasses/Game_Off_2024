extends Student

@onready var grid_bg = $Control/GridBG
@onready var character_art = $Control/CharacterArt
@onready var debug_label = $Control/DebugLabel
@onready var marker = $Marker2D

# colors
@export var highlight_green := Color(1.0, 0.89, 0.46, 1)
@export var highlight_red := Color(1.0, 0.42, 0.42, 1) 

var grid_position : Vector2i
var is_friend: bool = false
var placement_valid = false

signal student_placed(student, seat_position)

func _ready():
		
	# Remove all default button styling
	flat = true

	# Remove focus visuals
	focus_mode = Control.FOCUS_NONE

	# Remove default hover effect
	mouse_default_cursor_shape = Control.CURSOR_ARROW  # Or whatever cursor you want

	# Remove all theme overrides that might add visuals
	add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	add_theme_stylebox_override("hover", StyleBoxEmpty.new())
	add_theme_stylebox_override("pressed", StyleBoxEmpty.new())
	add_theme_stylebox_override("disabled", StyleBoxEmpty.new())
	
	# connect signals
	var level = get_node("/root/Level") # or however your scene is structured
	connect("student_clicked", level._on_student_clicked)
	connect("student_placed", level._on_student_placed)
	
	var panel_center = Vector2(
	grid_bg.global_position.x + (grid_bg.size.x / 2),
	grid_bg.global_position.y + (grid_bg.size.y / 2)
	)
	marker.global_position = panel_center

func set_grid_position(pos: Vector2i):
	grid_position = pos

func _apply_name(student_name):
	#highlight(true)
	if "empty" in student_name:
		set_desk_empty()
	else:
		character_art.show() # TODO: should set this to the correct sprite when art is in
		debug_label.show()
		self.name = student_name
		debug_label.get_node("Label").text = student_name

func set_desk_empty():
	empty_desk = true
	character_art.hide()
	debug_label.hide()

func make_player():
	self.add_to_group("player")

func _on_pressed():
	if empty_desk:
		if Globals.selected_student:
			print("Seating student: ", Globals.selected_student)
			student_placed.emit(Globals.selected_student, self)
	else:		
		student_clicked.emit(self)

func receive_note():
	#note_icon.show()
	has_note = true
	#var tween = create_tween()
	#tween.tween_property(self, "modulate", Color(1.2, 1.2, 1.2), 0.05)

func passed_note():
	#note_icon.hide()
	print(self.name, " passed the note.")
	has_note = false
	#var tween = create_tween()
	#tween.tween_property(self, "modulate", Color.WHITE, 0.05)
	
func highlight(valid: bool) -> void:
	#grid_bg.show()
	grid_bg.modulate.a = 1
	if valid:
		placement_valid = true
		grid_bg.modulate = highlight_green
	else:
		placement_valid = false
		grid_bg.modulate = highlight_red
	#
#func unhighlight():
	##grid_bg.hide()
	#grid_bg.modulate.a = 0
#
#func _on_mouse_entered():
	#if has_note:
		#return
	#else:
		#var tween = create_tween()
		#tween.tween_property(self, "modulate", Color(1.2, 1.2, 1.2), 0.05)
#
#func _on_mouse_exited():
	#if has_note:
		#return
	#else:
		#var tween = create_tween()
		#tween.tween_property(self, "modulate", Color.WHITE, 0.05)
