extends TextureButton

signal next_level

func _on_pressed():
	custom_minimum_size += Vector2(5,5)
	
func _on_button_up():
	custom_minimum_size -= Vector2(5,5)
	next_level.emit()
