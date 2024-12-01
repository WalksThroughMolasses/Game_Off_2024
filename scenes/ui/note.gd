extends Control

var off_screen_pos: Vector2 = Vector2(0,1100)
var transition_time: float = 0.9
var current_note : int = 1
var animation_playing : bool = true

const note_content_textures = {
	1: preload("res://assets/sprites/notes/Note_01.png"),
	2: preload("res://assets/sprites/notes/Note_02.png"),
	3: preload("res://assets/sprites/notes/Note_03.png"),
	4: preload("res://assets/sprites/notes/Note_04.png"),
	5: preload("res://assets/sprites/notes/Note_05.png"),
	6: preload("res://assets/sprites/notes/Note_06.png"),
}

const character_art_textures = {
	"player_female": preload("res://assets/sprites/characters/Player_Female_large.png"),
	"player_male": preload("res://assets/sprites/characters/Player_Male_large.png"),
	"bff_female": preload("res://assets/sprites/characters/BFF_large.png")
}


@onready var note_content = %NoteContent
@onready var character_art = $CharacterArt
@onready var mask_animation = %MaskAnimation

func _ready():
	note_content.texture = note_content_textures[Globals.current_level]
	self.position = Vector2.ZERO
	
	#var material = note_content.material as ShaderMaterial
	#material.set_shader_parameter("mask_texture", mask_animation.texture)

func _input(event):
	if animation_playing == true:
		return
	if event.is_action_pressed("click"):
		animation_playing = false
		await get_tree().create_timer(0.2).timeout  
		_on_start_next_level()

func display_next_note():
	note_content.texture = note_content_textures[Globals.current_level]
	
	if Globals.current_level == 6:
		character_art.texture = character_art_textures["bff_female"]
	else:
		if Globals.current_level % 2 != 0:
			character_art.texture = character_art_textures["player_female"]
		else:
			character_art.texture = character_art_textures["player_male"]
		
	
	self.position = Vector2.ZERO
	# Play scribble sound
	AudioController.play_sfx("scribble")
	
	mask_animation.play()

func _on_start_next_level():
	animation_playing = true
	var tween: Tween
	
	tween = create_tween()
	tween.tween_property(self, "position", off_screen_pos, transition_time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(func(): animation_playing = false)
	
func _on_mask_animation_animation_finished():
	animation_playing = false
