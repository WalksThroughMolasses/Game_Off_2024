extends Button
class_name Student

var has_note : bool = false
var empty_desk : bool = false
var is_moveable: bool = true

signal student_clicked(student)
	
func set_student_name(student_name: String):
	self.name = student_name
	_apply_name(student_name)

func _apply_name(_name: String):
	pass # placeholder function - logic is handled in friend.gd
