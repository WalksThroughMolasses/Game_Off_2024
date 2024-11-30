extends Control

func _ready():
	# Load the custom images for the mouse cursor
	Input.set_custom_mouse_cursor(Globals.cursor, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(Globals.cursor, Input.CURSOR_FORBIDDEN)

func _on_start_next_level():
	get_tree().change_scene_to_file.bind("res://scenes/levels/game.tscn").call_deferred()
