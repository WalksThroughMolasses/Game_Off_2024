extends Button
class_name Student

@onready var select_square = $Container/SelectSquare
#@onready var note_icon = $NoteIcon
@onready var label = $Container/Label

var has_note : bool = false
var student_traits : Array = []

signal student_clicked(body)

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
	
func set_student_name(student_name):
	self.name = student_name
	label.text = student_name

func make_player():
	self.add_to_group("player")

func has_trait(trait_name: String) -> bool:
	return student_traits.has(trait_name)

func _on_pressed():
	print("clicked ", self)
	student_clicked.emit(self)

func receive_note():
	#note_icon.show()
	has_note = true
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.2, 1.2, 1.2), 0.05)

func passed_note():
	#note_icon.hide()
	print(self.name, " passed the note.")
	has_note = false
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.05)
	
func highlight():
	#select_square.show()
	select_square.modulate.a = 1
	
func unhighlight():
	#select_square.hide()
	select_square.modulate.a = 0

func _on_mouse_entered():
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


