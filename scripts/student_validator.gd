extends Node
class_name StudentValidator

class ValidationResult:
	var valid: bool
	var reason: String
	
	func _init(is_valid: bool = true, error_reason: String = ""):
		valid = is_valid
		reason = error_reason

var classroom_data: Array
var desk_grid: Node
var level_config: Dictionary

func _init(classroom: Array, desks: Node, config: Dictionary):
	classroom_data = classroom
	desk_grid = desks
	level_config = config

func check_adjacent_rules(student: Student, desk: Student) -> ValidationResult:
	# Skip for special students
	if student.name == "player" or student.name == "crush":
		return ValidationResult.new()
		
	# Check if desk is occupied
	if not desk.name.begins_with("empty") and desk != student:
		return ValidationResult.new(false, "Desk is already occupied")
	
	# Check adjacent rules
	if level_config["student_configs"].has(student.name):
		var student_config = level_config["student_configs"][student.name]
		if student_config.has("rules"):
			for rule in student_config.rules:
				if rule is AdjacentRule:
					var result = rule.check_valid(student, desk, classroom_data, desk_grid)
					if not result.valid:
						return ValidationResult.new(false, result.reason)
	
	return ValidationResult.new()

func check_sequence_rules(student: Student, note_chain: Array) -> ValidationResult:
	if level_config["student_configs"].has(student.name):
		var student_config = level_config["student_configs"][student.name]
		if student_config.has("rules"):
			for rule in student_config.rules:
				if rule is SequenceRule:
					var result = rule.check_valid(student, note_chain, classroom_data, desk_grid)
					if not result.valid:
						return ValidationResult.new(false, result.reason)
	
	return ValidationResult.new()

func update_student_feedback(student: Student, result: ValidationResult):
	student.invalid_reason = result.reason if not result.valid else ""
	if student is Avatar:
		student.highlight(result.valid)
