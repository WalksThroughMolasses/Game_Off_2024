extends Student
class_name Avatar

@onready var grid_bg = $Control/Panel/GridBG

@onready var debug_label = $Control/Panel/Label
@onready var marker = $Control/Panel/Marker2D
@onready var heart = $Control/Heart

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
	#highlight(true)
	if "empty" in student_name:
		set_desk_empty()
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

		character_art.texture = character_textures[student_name]
		character_art.show()
		
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
	
	self.is_moveable = false
	self.is_friend = true

func make_crush():
	#character_art.texture = character_textures["crush"]
	self.add_to_group("crush")
	self.remove_from_group("player")
	
	heart.show()
	
	self.is_moveable = false
	self.is_friend = true

func receive_note():
	#note_icon.show()
	has_note = true
	#var tween = create_tween()
	#tween.tween_property(self, "modulate", Color(1.2, 1.2, 1.2), 0.05)

func passed_note():
	#note_icon.hide()
	print(self.name, " passed the note.")
	has_note = false
	#var tween = create_tween()
	#tween.tween_property(self, "modulate", Color.WHITE, 0.05)
	
func highlight(valid: bool) -> void:

	if valid:
		placement_valid = true
		grid_bg.modulate = highlight_valid_placement
	else:
		placement_valid = false
		grid_bg.modulate = highlight_invalid_placement
	
	if !is_friend:
		grid_bg.modulate = highlight_immovable

#func unhighlight():
	##grid_bg.hide()
	#grid_bg.modulate.a = 0
	
func show_preview(student_name):
	character_art.texture = character_textures[student_name]
	character_art.modulate.a = 0.5
	character_art.show()
	
func hide_preview():
	character_art.texture = character_textures["empty_desk"]
	character_art.modulate.a = 1
	character_art.hide()

func _on_mouse_entered():
	if empty_desk && Globals.selected_student:
		print("empty? ", empty_desk)
		print(Globals.selected_student)
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(1.1, 1.1, 1.1), 0.05)

func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0, 1.0, 1.0), 0.05)
