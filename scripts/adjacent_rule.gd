class_name AdjacentRule
extends Node

var config: Dictionary

func _init(rule_config: Dictionary = {}):
	config = rule_config
	
func check_valid(student: Student, target_desk: Student, classroom: Array, desk_grid: Node) -> Dictionary:
	var result = {"valid": true, "reason": ""}

	print("Checking adjacency for ", student.name)
	print("Config: ", config)
	
	#if not config.has("cant_sit_next_to"):
		#print("No cant_sit_next_to rules defined")
		#return result
	
	var target_pos = Utils.get_desk_position(target_desk, classroom, desk_grid)
	print("Target position: ", target_pos)  # Add this
	var adjacent_positions = Utils.get_adjacent_positions(target_pos, classroom)
	print("Generated adjacent positions: ", adjacent_positions) 
	
	 # Check forbidden adjacencies with exceptions
	if config.has("cant_sit_next_to"):
		for pos in adjacent_positions:
			var desk_index = pos.y * classroom[0].size() + pos.x
			print("Position: ", pos, " -> desk_index: ", desk_index)
			var adjacent_student = desk_grid.get_child(desk_index)
			print("Checking adjacent student: ", adjacent_student.name)

			if config.cant_sit_next_to.has(adjacent_student.name):
				# Check if there's an unless_adjacent condition for this student
				if config.has("unless_adjacent") and config.unless_adjacent.has(adjacent_student.name):
					# Check if any of the supporting students are adjacent
					var has_support = false
					for support_pos in adjacent_positions:
						var support_index = support_pos.y * classroom[0].size() + support_pos.x
						var support_student = desk_grid.get_child(support_index)
						if config.unless_adjacent[adjacent_student.name].has(support_student.name):
							has_support = true
							break

					if not has_support:
						result.valid = false
						result.reason = "Can't sit next to " + adjacent_student.name + " without support"
						return result
				else:
					# No unless condition, straight invalid
					result.valid = false
					result.reason = "Can't sit next to " + adjacent_student.name
					return result

	# Check required adjacencies (OR condition)
	if config.has("must_sit_next_to"):
		var found_required = false
		for pos in adjacent_positions:
			var desk_index = pos.y * classroom[0].size() + pos.x
			var adjacent_student = desk_grid.get_child(desk_index)

			if config.must_sit_next_to.has(adjacent_student.name):
				found_required = true
				break

		if not found_required:
			result.valid = false
			result.reason = "Must sit next to at least one of: " + str(config.must_sit_next_to)
			return result

	return result
