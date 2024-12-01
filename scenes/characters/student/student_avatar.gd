extends Student
class_name Avatar

@onready var grid_bg = $Control/Panel/GridBG

@onready var debug_label = $Control/Panel/Label
@onready var marker = $Control/Panel/Marker2D
@onready var heart = $Control/Heart
@onready var broken_heart = $Control/BrokenHeart
@onready var player_icon = $Control/PlayerIcon

# colors
@export var highlight_valid_placement := Color("#FFE375FF")
@export var highlight_invalid_placement := Color("#FA5F5FFF")
@export var highlight_immovable := Color("#A2C4E3FF")

var grid_position : Vector2i
var placement_valid = false

func _ready():
	
	super()
	
	character_art = $Control/Panel/CharacterArt

	var panel_center = Vector2(
	grid_bg.global_position.x + (grid_bg.size.x / 2),
	grid_bg.global_position.y + (grid_bg.size.y / 2)
	)
	marker.global_position = panel_center
	
	character_art.show()

func set_grid_position(pos: Vector2i):
	grid_position = pos

func _apply_name(student_name):
	if "empty" in student_name:
		set_desk_empty()
	else:
		character_art.texture = character_textures[student_name]
		character_art.show()
		
		# Special case for last level
		if Globals.current_level == 6:
			if student_name == "bff_female":
				self.make_player()
			elif student_name == "player_female":
				self.make_crush()
			elif student_name == "player_male":
				self.is_friend = false
				self.is_moveable = false
		else:
			if student_name == "player_female":
				if Globals.current_level % 2 != 0:
					self.make_player()
				else:
					self.make_crush()
			elif student_name == "player_male":
				if Globals.current_level % 2 != 0:
					self.make_crush()
				else:
					self.make_player()
		
		debug_label.text = student_name
		
func shake(duration: float = 0.3, strength: float = 3.0):
	var start_pos = self.position
	var elapsed_time = 0.0
	var shake_interval = 0.05  # Change position every 0.05 seconds
	var time_since_last_shake = 0.0
	
	while elapsed_time < duration:
		elapsed_time += get_process_delta_time()
		time_since_last_shake += get_process_delta_time()
		
		if time_since_last_shake >= shake_interval:
			var offset = Vector2(
				randf_range(-strength, strength),
				randf_range(-strength, strength)
			)
			self.position = start_pos + offset
			time_since_last_shake = 0.0
			
		await get_tree().process_frame
		
	# Reset to original position
	self.position = start_pos

func set_desk_empty():
	empty_desk = true
	is_moveable = true
	is_friend = true
	self.name = "empty"
	self.highlight(true)
	character_art.hide()
	debug_label.hide()

func make_player():
	#character_art.texture = character_textures["player"]
	self.add_to_group("player")
	self.remove_from_group("crush")
	
	if Globals.current_level == 5:
		character_art.texture = character_textures["player_female_sad"]
	
	player_icon.show()
	
	self.is_moveable = false
	self.is_friend = true
	
	grab_focus()

func make_crush():

	self.add_to_group("crush")
	self.remove_from_group("player")
	
	if Globals.current_level == 6:
		character_art.texture = character_textures["player_female_sad"]
	
	if Globals.current_level == 5 or Globals.current_level == 6:
		broken_heart.show()
	else:
		heart.show()
	
	self.is_moveable = false
	self.is_friend = true

func receive_note():
	has_note = true

func passed_note():
	print(self.name, " passed the note.")
	has_note = false

func highlight(valid: bool) -> void:

	if valid:
		placement_valid = true
		grid_bg.modulate = highlight_valid_placement
	else:
		placement_valid = false
		grid_bg.modulate = highlight_invalid_placement
	
	if !is_friend:
		grid_bg.modulate = highlight_immovable
	
func show_preview(student_name):
	character_art.texture = character_textures[student_name]
	character_art.modulate.a = 0.5
	character_art.show()
	
func hide_preview():
	character_art.texture = character_textures["empty_desk"]
	character_art.modulate.a = 1
	character_art.hide()
	
func heartbeat_animation():
	
	# Special case for last level
	if Globals.current_level == 6:
		character_art.texture = character_textures["player_female"]
		broken_heart.hide()
		heart.show()
	
	var tween = create_tween()
	tween.set_loops(5)  # Set how many times you want it to loop

	# First beat - stronger
	tween.tween_property(heart, "scale", Vector2(1.3, 1.3), 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_property(heart, "scale", Vector2(1.0, 1.0), 0.1).set_ease(Tween.EASE_IN)

	# Brief pause between beats
	tween.tween_interval(0.1)

	# Second beat - softer
	tween.tween_property(heart, "scale", Vector2(1.15, 1.15), 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_property(heart, "scale", Vector2(1.0, 1.0), 0.1).set_ease(Tween.EASE_IN)

	# Rest period before next heartbeat
	tween.tween_interval(0.4)

#func _on_mouse_entered():
	#if empty_desk && Globals.selected_student:
		#print("empty? ", empty_desk)
		#print(Globals.selected_student)
		#var tween = create_tween()
		#tween.tween_property(self, "modulate", Color(1.1, 1.1, 1.1), 0.05)
#
#func _on_mouse_exited():
	#var tween = create_tween()
	#tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0), 0.05)
