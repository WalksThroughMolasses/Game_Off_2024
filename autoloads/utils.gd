extends Node

static func get_adjacent_positions(pos: Vector2i, classroom: Array) -> Array[Vector2i]:
	var adjacent: Array[Vector2i] = []
	# Same row
	if pos.y > 0:
		adjacent.append(Vector2i(pos.x, pos.y - 1))
	if pos.y < classroom[0].size() - 1:
		adjacent.append(Vector2i(pos.x, pos.y + 1))
	# Same column    
	if pos.x > 0:  # Changed from pos.y
		adjacent.append(Vector2i(pos.x - 1, pos.y))  # Changed order
	if pos.x < classroom.size() - 1:  # Changed from pos.y
		adjacent.append(Vector2i(pos.x + 1, pos.y))  # Changed order
		
	return adjacent

func get_desk_position(student: Student, classroom: Array, desk_grid: Node = null) -> Vector2i:
	# Handle empty desks
	if student.name.begins_with("empty"):
		for row in classroom.size():
			for col in classroom[row].size():
				var desk_index = row * classroom[0].size() + col
				# Only check if we were passed the desk grid
				if desk_grid and desk_grid.get_child(desk_index) == student and classroom[row][col] == "empty":
					return Vector2i(col, row)
	else:
		# Named students
		for row in classroom.size():
			for col in classroom[row].size():
				if classroom[row][col] == student.name:
					return Vector2i(col, row)

	return Vector2i(-1, -1)
