extends Student

@onready var grid_bg = $Control/GridBG
@onready var debug_label = $Control/DebugLabel

var grid_position: Vector2i

func _ready():
	character_art = $Control/CharacterArt

func set_grid_position(pos: Vector2i):
	grid_position = pos

func _apply_name(student_name):
	if "Empty" in student_name:
		set_desk_empty()
	else:
		character_art.show() # TODO: should set this to the correct sprite when art is in
		debug_label.show()
		self.name = student_name
		debug_label.get_node("Label").text = student_name

func set_desk_empty():
	empty_desk = true
	character_art.hide()
	debug_label.hide()

func make_player():
	self.add_to_group("player")

#func has_trait(trait_name: String) -> bool:
	#return student_traits.has(trait_name)

func _on_pressed():
	student_clicked.emit(self)

func receive_note():
	#note_icon.show()
	has_note = true
	#var tween = create_tween()
	#tween.tween_property(self, "modulate", Color(1.2, 1.2, 1.2), 0.05)

func passed_note():
	#note_icon.hide()
	print(self.name, " passed the note.")
	has_note = false
	#var tween = create_tween()
	#tween.tween_property(self, "modulate", Color.WHITE, 0.05)
	
func highlight():
	#grid_bg.show()
	grid_bg.modulate.a = 1
	
func unhighlight():
	#grid_bg.hide()
	grid_bg.modulate.a = 0

func _on_mouse_entered():
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
