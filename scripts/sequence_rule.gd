class_name SequenceRule
extends Node

enum Direction {
	NORTH = Globals.Direction.NORTH,
	SOUTH = Globals.Direction.SOUTH,
	EAST = Globals.Direction.EAST,
	WEST = Globals.Direction.WEST
}
enum Requirement { 
	BEFORE = Globals.Requirement.BEFORE, 
	AFTER = Globals.Requirement.AFTER 
}

const DIRECTION_NAMES = {
	Direction.NORTH: "behind",
	Direction.SOUTH: "in front",
	Direction.EAST: "the left",
	Direction.WEST: "the right"
}

var config: Dictionary

func _init(rule_config: Dictionary = {}):
	config = rule_config
	
func get_readable_directions(directions: Array) -> String:
	if directions.size() == 0:
		return ""
	
	var readable_dirs = []
	for dir in directions:
		readable_dirs.append(DIRECTION_NAMES[dir])
	
	if readable_dirs.size() == 1:
		return readable_dirs[0]
	elif readable_dirs.size() == 2:
		return readable_dirs[0] + " or " + readable_dirs[1]
	else:
		var last = readable_dirs.pop_back()
		return ", ".join(readable_dirs) + ", or " + last

func check_valid(student: Student, note_chain: Array, classroom: Array, desk_grid: Node, student_configs: Dictionary) -> Dictionary:
	var result = {"valid": true, "reason": ""}
	
	# Get student's position in chain
	var student_index = note_chain.find(student)
	if student_index == -1:
		return result  # Student not in chain, no sequence rules to check
		
	# Check directional rules
	if config.has("direction"):
		if config.direction.has("cant_receive_from"):
			var prev_student = note_chain[student_index - 1] if student_index > 0 else null
			if prev_student:
				var direction = get_receive_from_direction(prev_student, student, classroom, desk_grid)
				if config.direction.cant_receive_from.has(direction):
					result.valid = false
					if typeof(config.direction.cant_receive_from) == TYPE_ARRAY:
						result.reason = "Can't receive note from " + get_readable_directions(config.direction.cant_receive_from) +  "."
					else:
						result.reason = "Can't receive note from " + DIRECTION_NAMES[direction] +  "."
					return result
					
		if config.direction.has("must_receive_from"):
			var prev_student = note_chain[student_index - 1] if student_index > 0 else null
			if prev_student:
				var direction = get_receive_from_direction(prev_student, student, classroom, desk_grid)
				if not config.direction.must_receive_from.has(direction):
					result.valid = false
					if typeof(config.direction.must_receive_from) == TYPE_ARRAY:
						result.reason = "Must receive note from " + get_readable_directions(config.direction.must_receive_from) +  "."
					else:
						result.reason = "Must receive note from " + DIRECTION_NAMES[direction] +  "."
					return result
				
	# Check order rules relative to other students
	if config.has("order"):
		if config.order.has("relative_to"):
			for other_student in config.order.relative_to:
				var other_index = -1
				for i in note_chain.size():
					if note_chain[i].name == other_student:
						other_index = i
						break

				if other_index != -1:  # Other student is in chain
					var requirement = config.order.relative_to[other_student]
					match requirement:
						Requirement.BEFORE:
							if student_index > other_index:
								result.valid = false
								result.reason = "Must receive note before " + student_configs[other_student]["name"]
						Requirement.AFTER:
							if student_index < other_index:
								result.valid = false
								result.reason = "Must receive note after " + student_configs[other_student]["name"]
						
		# Check chain index requirements
		if config.order.has("chain_index"):
			for index in config.order.chain_index:
				var requirement = config.order.chain_index[index]
				match requirement:
					Requirement.BEFORE:
						if student_index >= index:
							result.valid = false
							result.reason = "Must be before step " + str(index) + "."
					Requirement.AFTER:
						if student_index <= index:
							result.valid = false
							result.reason = "Must be after step " + str(index) + "."
							
	return result

func get_receive_from_direction(from_student: Student, to_student: Student, classroom: Array, desk_grid: Node) -> Direction:
	var from_pos = Utils.get_desk_position(from_student, classroom, desk_grid)
	var to_pos = Utils.get_desk_position(to_student, classroom, desk_grid)
	var pass_direction : int
	
	if from_pos.y < to_pos.y:
		pass_direction = Direction.NORTH
	elif from_pos.y > to_pos.y:
		pass_direction = Direction.SOUTH
	elif from_pos.x < to_pos.x:
		pass_direction = Direction.WEST
	else:
		pass_direction = Direction.EAST
	
	print("Received note from: ", pass_direction, " (", Direction.keys()[pass_direction], ")")
	return pass_direction
