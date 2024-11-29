extends Student
class_name Icon

@onready var debug_label = $Label

var debug_on: bool = Globals.debug_on

signal student_clicked(student)

func _ready():
	
	# connect signals
	connect("student_clicked", level._on_student_clicked)
	
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

func _on_pressed():
	print("clicked ", self)
	student_clicked.emit(self)
	
func highlight(_valid: bool):
	$TextureRect.modulate.a = 1
	print("It's the icon!")
	#
func unhighlight(_valid: bool):
	$TextureRect.modulate.a = 0

#func _on_mouse_entered():
	#print("mouse")
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


