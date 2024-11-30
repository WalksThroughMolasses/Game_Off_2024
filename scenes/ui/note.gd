extends Control

var off_screen_pos: Vector2 = Vector2(0,1100)
var transition_time: float = 0.5
var current_note : int = 1

const note_content_textures = {
	1: preload("res://assets/sprites/TEMP_note.png"),
	2: preload("res://assets/sprites/TEMP_note.png"),
	3: preload("res://assets/sprites/TEMP_note.png"),
	4: preload("res://assets/sprites/TEMP_note.png"),
	5: preload("res://assets/sprites/TEMP_note.png"),
	6: preload("res://assets/sprites/TEMP_note.png"),
	7: preload("res://assets/sprites/TEMP_note.png"),
	8: preload("res://assets/sprites/TEMP_note.png")
}

@onready var note_content = %NoteContent

func _ready():
	note_content.texture = note_content_textures[current_note]
	self.position = Vector2.ZERO

func display_next_note():
	current_note += 1
	note_content.texture = note_content_textures[current_note]
	self.position = Vector2.ZERO
	
	# Play bell sound
	

func _on_start_next_level():
	var tween: Tween
	
	tween = create_tween()
	tween.tween_property(self, "position", off_screen_pos, transition_time).set_ease(Tween.EASE_IN_OUT)
