extends HBoxContainer

var first_turn = true
@onready var turn_icon_scene: PackedScene = preload("res://scenes/ui/turn_icon.tscn")

func update(turn_number):
	print("Turn number: ", turn_number)
	var current_icons = self.get_child_count()
	print("Current icons: ", current_icons)
	
	## Don't exceed 6 icons # TODO: handle this in main script
	#if turn_number > 6:
		#return
		
	# Add or remove icons to match turn_number
	if turn_number > current_icons:
		# Need to add icons
		var new_turn_icon = turn_icon_scene.instantiate()
		self.add_child(new_turn_icon)
	elif turn_number < current_icons:
		# Need to remove icons
		self.get_children()[-1].queue_free()
	
	first_turn = false
