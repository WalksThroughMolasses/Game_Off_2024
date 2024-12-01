extends TextureButton

signal next_level

func _on_pressed():
	# Play sound
	AudioController.play_sfx("place")
	
func _on_button_up():
	next_level.emit()
