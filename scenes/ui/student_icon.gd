extends Student

@onready var debug_label = $Label

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
	#select_square.hide()
	
func _apply_name(student_name):
	print("StudentIcon _apply_name called with: ", student_name)
	debug_label.show()
	self.name = student_name
	debug_label.text = student_name

func _on_pressed():
	print("clicked ", self)
	student_clicked.emit(self)
	
func highlight(valid: bool):
	$TextureRect.modulate.a = 1
	print("It's the icon!")
	#
func unhighlight(valid: bool):
	$TextureRect.modulate.a = 0

func _on_mouse_entered():
	print("mouse")
	if has_note:
		return
	else:
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(1.2, 1.2, 1.2), 0.05)

func _on_mouse_exited():
	if has_note:
		return
	else:
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color.WHITE, 0.05)


