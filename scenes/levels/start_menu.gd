extends Control

@onready var note_text = $MarginContainer/VBoxContainer
@onready var start_button = $MarginContainer/VBoxContainer/CenterContainer/Start
@onready var level = get_node("/root/Level")

func _ready():
	note_text.modulate.a = 0
	start_button.disabled = true
	fade_in_text()
	
	# Load the custom images for the mouse cursor
	Input.set_custom_mouse_cursor(Globals.cursor, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(Globals.cursor, Input.CURSOR_FORBIDDEN)

func _on_start_next_level():
	fade_out_text()
	
func fade_in_text():
	var tween = create_tween()
	tween.tween_property(note_text, "modulate", Color(1, 1, 1, 1), 1.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(_on_fade_in_completed)

func fade_out_text():
	var tween = create_tween()
	tween.tween_property(note_text, "modulate", Color(1, 1, 1, 0), 1.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(_on_fade_out_completed)
	
func _on_fade_in_completed():
	start_button.disabled = false
	
func _on_fade_out_completed():
	await get_tree().create_timer(0.6).timeout
	self.hide()
	level.load_level_config()
	level.setup_level()
	
	
