extends Control

@onready var note_text = $MarginContainer/VBoxContainer
@onready var level = get_node("/root/Level")

#const game = preload("res://scenes/levels/game.tscn")

func _ready():
	# Load the custom images for the mouse cursor
	Input.set_custom_mouse_cursor(Globals.cursor, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(Globals.cursor, Input.CURSOR_FORBIDDEN)

func _on_start_next_level():
	fade_out_text()

func fade_out_text():
	var tween = create_tween()
	tween.tween_property(note_text, "modulate", Color(1, 1, 1, 0), 1.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(_on_fade_completed)
	
func _on_fade_completed():
	await get_tree().create_timer(1).timeout
	self.hide()
	level.load_level_config()
	level.setup_level()
	
	
