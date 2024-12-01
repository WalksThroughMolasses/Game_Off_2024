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
	7: preload("res://assets/sprites/notes/End_Screen_03.png")
}

const character_art_textures = {
	"player_female": preload("res://assets/sprites/characters/Player_Female_large.png"),
	"player_female_sad": preload("res://assets/sprites/characters/Player_Female_Sad.png"),
	"player_male": preload("res://assets/sprites/characters/Player_Male_large.png"),
	"bff_female": preload("res://assets/sprites/characters/BFF_large.png")
}

@onready var note_content = %NoteContent
@onready var character_art = $CharacterArt
@onready var mask_animation = %MaskAnimation
@onready var level = get_node("/root/Level")

func _ready():
	note_content.texture = note_content_textures[Globals.current_level]
	self.position = Vector2.ZERO

func _input(event):
	if event.is_action_pressed("click"):
		if Globals.game_over:
			animation_playing = true
			current_note = 1
			fade_out_image()
			return
		
		elif not animation_playing:
			animation_playing = true
			await get_tree().create_timer(0.2).timeout
			_on_start_next_level()
		
func fade_in_image():
	var tween = create_tween()
	tween.tween_property(character_art, "modulate", Color(1, 1, 1, 1), 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(_on_fade_in_completed)

func fade_out_image():
	var tween = create_tween()
	tween.tween_property(note_content, "modulate", Color(1, 1, 1, 0), 2.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(_on_fade_out_completed)

func display_next_note():
	animation_playing = true
	mask_animation.frame = 0
	note_content.hide()
	
	note_content.texture = note_content_textures[Globals.current_level]
	character_art.modulate.a = 0
	
	if Globals.current_level == 5:
		character_art.texture = character_art_textures["player_female_sad"]
	if Globals.current_level == 6:
		character_art.texture = character_art_textures["bff_female"]
	elif Globals.current_level > 6:
		character_art.hide()
	else:
		if Globals.current_level % 2 != 0:
			character_art.texture = character_art_textures["player_female"]
		else:
			character_art.texture = character_art_textures["player_male"]
		
	self.position = Vector2.ZERO
	
	fade_in_image()

func _on_start_next_level():
	animation_playing = true
	var tween: Tween
	
	tween = create_tween()
	tween.tween_property(self, "position", off_screen_pos, transition_time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(func(): animation_playing = false)
	
func _on_mask_animation_animation_finished():
	animation_playing = false
	
func _on_fade_in_completed():
	# Play scribble sound
	note_content.show()
	mask_animation.play()
	await get_tree().create_timer(0.4).timeout
	AudioController.play_sfx("scribble")

func _on_fade_out_completed():
	level.restart_game()
