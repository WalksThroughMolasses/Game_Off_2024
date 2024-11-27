extends Control

@onready var student_name = %StudentName
@onready var student_description = %StudentDescription
@onready var confirm_pass_note = %ConfirmPassNote

func _ready():
	pass

func set_text(student_profile):
	# just for debug purposes
	if typeof(student_profile) == TYPE_STRING:
		student_description.bbcode_text = student_profile
	else:
		student_name.text = student_profile["name"]
		student_description.text = student_profile["description"][0]

func _on_close_profile_pressed():
	self.hide()
