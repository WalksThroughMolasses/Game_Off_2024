extends Button
class_name Student

var has_note : bool = false
var empty_desk : bool = false
var is_moveable: bool = true
var rules: Array[StudentRule] = []

signal student_clicked(student)

func validate_placement() -> bool:
	for rule in rules:
		if not rule.check_valid(self):
			return false
	return true
	
func set_student_name(student_name: String):
	self.name = student_name
	_apply_name(student_name)

func _apply_name(name: String):
	pass # placeholder function - logic is handled in friend and student_avatar
