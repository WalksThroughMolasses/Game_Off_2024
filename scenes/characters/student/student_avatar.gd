extends Student

const character_textures = {
	"photographer": preload("res://assets/sprites/characters/Photographer.png"),
	"bff_female": preload("res://assets/sprites/characters/BFF_01.png"),
	"bff_male": preload("res://assets/sprites/characters/BFF_02.png"),
	"bully_01": preload("res://assets/sprites/characters/Bully_01.png"),
	"bully_02": preload("res://assets/sprites/characters/Bully_02.png"),
	"player_male": preload("res://assets/sprites/characters/Player_Male.png"),
	"crying": preload("res://assets/sprites/characters/Crying.png"),
	"frog": preload("res://assets/sprites/characters/Frog.png"),
	"furry": preload("res://assets/sprites/characters/Furry.png"),
	"musician": preload("res://assets/sprites/characters/Musician.png"),
	"headphones": preload("res://assets/sprites/characters/Headphones.png"),
	"player_female": preload("res://assets/sprites/characters/Player_Female.png"),
	"poser": preload("res://assets/sprites/characters/Poser.png"),
	"posh": preload("res://assets/sprites/characters/Posh.png"),
	"shakas": preload("res://assets/sprites/characters/Shakas.png"),
	"sick": preload("res://assets/sprites/characters/Sick.png"),
	"sleepy": preload("res://assets/sprites/characters/Sleepy.png"),
	"smelly": preload("res://assets/sprites/characters/Smelly.png"),
	"twin_01": preload("res://assets/sprites/characters/TwinA.png"),
	"twin_02": preload("res://assets/sprites/characters/TwinB.png")
}

@onready var grid_bg = $Control/Panel/GridBG
@onready var character_art = $Control/Panel/CharacterArt
@onready var debug_label = $Control/Panel/Label
@onready var marker = $Control/Panel/Marker2D

# colors
@export var highlight_valid_placement := Color("#FFE375FF")
@export var highlight_invalid_placement := Color("#FA5F5FFF")
@export var highlight_immovable := Color("#A2C4E3FF")

var grid_position : Vector2i
var is_friend: bool = false
var placement_valid = false

signal student_placed(student, seat_position)

func _ready():
		
	# Remove all default button styling
	flat = true

	# Remove focus visuals
	focus_mode = Control.FOCUS_NONE

	# Remove default hover effect
	mouse_default_cursor_shape = Control.CURSOR_ARROW  # Or whatever cursor you want

	# Remove all theme overrides that might add visuals
	add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	add_theme_stylebox_override("hover", StyleBoxEmpty.new())
	add_theme_stylebox_override("pressed", StyleBoxEmpty.new())
	add_theme_stylebox_override("disabled", StyleBoxEmpty.new())
	
	# connect signals
	var level = get_node("/root/Level") # or however your scene is structured
	connect("student_clicked", level._on_student_clicked)
	connect("student_placed", level._on_student_placed)

	var panel_center = Vector2(
	grid_bg.global_position.x + (grid_bg.size.x / 2),
	grid_bg.global_position.y + (grid_bg.size.y / 2)
	)
	marker.global_position = panel_center
	
	#if !is_moveable:
		#grid_bg.modulate = highlight_immovable

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
		self.name = student_name
		debug_label.text = student_name

func set_desk_empty():
	empty_desk = true
	is_moveable = true
	is_friend = true
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
	
	self.is_moveable = false
	self.is_friend = true

func _on_pressed():
	if empty_desk:
		if Globals.selected_student:
			print("Seating student: ", Globals.selected_student)
			student_placed.emit(Globals.selected_student, self)
	else:		
		student_clicked.emit(self)

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
#
#func _on_mouse_entered():
	#if has_note:
		#return
	#else:
		#var tween = create_tween()
		#tween.tween_property(self, "modulate", Color(1.1, 1.1, 1.1), 0.05)
#
#func _on_mouse_exited():
	#if has_note:
		#return
	#else:
		#var tween = create_tween()
		#tween.tween_property(self, "modulate", Color.WHITE, 0.05)
