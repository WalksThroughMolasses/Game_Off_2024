extends Student

@onready var debug_label = $Label
@onready var character_art = $CharacterArt

var debug_on: bool = Globals.debug_on

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

# Called when the node enters the scene tree for the first time.
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
	#select_square.hide()
	
	debug_label.hide()
	
func _apply_name(student_name):
	print("StudentIcon _apply_name called with: ", student_name)
	character_art.texture = character_textures[student_name]
	if debug_on:
		debug_label.show()
		debug_label.text = student_name
		
	self.name = student_name

func _on_pressed():
	print("clicked ", self)
	student_clicked.emit(self)
	
func highlight(_valid: bool):
	$TextureRect.modulate.a = 1
	print("It's the icon!")
	#
func unhighlight(_valid: bool):
	$TextureRect.modulate.a = 0

func _on_mouse_entered():
	print("mouse")
	if has_note:
		return
	else:
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(1.2, 1.2, 1.2), 0.05)

func _on_mouse_exited():
	if has_note:
		return
	else:
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color.WHITE, 0.05)


