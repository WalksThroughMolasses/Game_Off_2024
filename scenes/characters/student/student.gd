extends Button
class_name Student

var has_note : bool = false
var empty_desk : bool = false
var is_moveable: bool = false
var is_friend: bool = false
var invalid_reason : String = ""
var character_art
var drop_target

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
	"twin_02": preload("res://assets/sprites/characters/TwinB.png"),
	"empty_desk": preload("res://assets/sprites/characters/Empty_select.png")
}

const character_icon_textures = {
	"photographer": preload("res://assets/sprites/characters/Photographer_select.png"),
	"bff_female": preload("res://assets/sprites/characters/BFF_01_select.png"),
	"bff_male": preload("res://assets/sprites/characters/BFF_02_select.png"),
	"bully_01": preload("res://assets/sprites/characters/Bully_01_select.png"),
	"bully_02": preload("res://assets/sprites/characters/Bully_02_select.png"),
	"crying": preload("res://assets/sprites/characters/Crying_select.png"),
	"frog": preload("res://assets/sprites/characters/Frog_select.png"),
	"furry": preload("res://assets/sprites/characters/Furry_select.png"),
	"musician": preload("res://assets/sprites/characters/Musician_select.png"),
	"headphones": preload("res://assets/sprites/characters/Headphones_select.png"),
	"player_female": preload("res://assets/sprites/characters/Player_Female.png"),
	"poser": preload("res://assets/sprites/characters/Poser_select.png"),
	"posh": preload("res://assets/sprites/characters/Posh_select.png"),
	"shakas": preload("res://assets/sprites/characters/Shakas_select.png"),
	"sick": preload("res://assets/sprites/characters/Sick_select.png"),
	"sleepy": preload("res://assets/sprites/characters/Sleepy_select.png"),
	"smelly": preload("res://assets/sprites/characters/Smelly_select.png"),
	"twin_01": preload("res://assets/sprites/characters/TwinA_select.png"),
	"twin_02": preload("res://assets/sprites/characters/TwinB_select.png")
}

@onready var drag_preview_scene = preload("res://scenes/ui/drag_preview.tscn")

@onready var level = get_node("/root/Level")
@onready var pressed_connection = pressed.connect(_on_pressed)

signal student_dragged(student)
signal student_clicked(student)

func _ready():
	# connect signals
	connect("student_dragged", level._on_student_dragged)
	connect("student_clicked", level._on_student_clicked)

func set_student_name(student_name: String):
	self.name = student_name
	_apply_name(student_name)

func _apply_name(_name: String):
	pass # placeholder function - logic is handled in friend.gd
	
func _on_pressed():
	student_clicked.emit(self)
	
func _get_drag_data(_at_position : Vector2):
	
	student_clicked.emit(self) # treat drag the same as click
	
	if is_friend && is_moveable && !empty_desk:
		AudioController.play_sfx("pop")

		character_art.modulate.a = 0.5

		var drag_preview = drag_preview_scene.instantiate()
		drag_preview.get_node("CharacterArt").texture = character_icon_textures[self.name]
		drag_preview.selected_student = self
		level.get_node("UI").add_child(drag_preview)

		student_dragged.emit(self)
