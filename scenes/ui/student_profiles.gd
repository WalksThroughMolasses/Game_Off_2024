extends Control

@onready var student_name_label = %StudentName
@onready var student_traits_label = %StudentTraits
@onready var confirm_pass_note = %ConfirmPassNote

func _ready():
	
	# connect signals
	var level = get_node("/root/Level") # or however your scene is structured
	confirm_pass_note.connect("pressed", level._on_confirm_pass_note_clicked)

func set_text(student_name):
	student_name_label.text = student_name

func _on_close_profile_pressed():
	self.hide()
