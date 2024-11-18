extends Button
class_name Student

var has_note : bool = false
var empty_desk : bool = false
var is_moveable: bool = true

signal student_clicked(student)
	
func set_student_name(student_name: String):
	self.name = student_name
	_apply_name(student_name)

func _apply_name(name: String):
	pass

# Called when the node enters the scene tree for the first time.
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
	#select_square.hide()

