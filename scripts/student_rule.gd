class_name StudentRule
extends Node

# This is the base class for all student-specific validation rules
func check_valid(student: Student) -> bool:
	# Implement rule-specific validation logic here
	return true

func get_invalid_reason() -> String:
	# Add a note to character profile saying that the placement is invalid
	return ""
