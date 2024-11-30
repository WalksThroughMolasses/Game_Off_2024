extends Student
class_name Icon

@onready var debug_label = $Label

var debug_on: bool = Globals.debug_on

func _ready():
	super()

	character_art = $CharacterArt
	
	debug_label.hide()
	
	is_friend = true
	is_moveable = true
	
func _apply_name(student_name):
	print("StudentIcon _apply_name called with: ", student_name)
	character_art.texture = character_icon_textures[student_name]
	if debug_on:
		debug_label.show()
		debug_label.text = student_name

func highlight(_valid: bool):
	pass
	#
func unhighlight(_valid: bool):
	pass


