extends Node

var initial_volumes = {}  # Dictionary to store initial volumes

@onready var ambience_track = preload("res://assets/audio/ambience/Ambience.mp3")
@onready var bell_audio_streams = {
	0: create_audio_stream("res://assets/audio/music/Bell_Note0_marimba.mp3"),
	1: create_audio_stream("res://assets/audio/music/Bell_Note1_marimba.mp3"),
	2: create_audio_stream("res://assets/audio/music/Bell_Note2_marimba.mp3"),
	3: create_audio_stream("res://assets/audio/music/Bell_Note3_marimba.mp3"),
	4: create_audio_stream("res://assets/audio/music/Bell_Note4_marimba.mp3"),
	5: create_audio_stream("res://assets/audio/music/Bell_Note5_marimba.mp3"),
	6: create_audio_stream("res://assets/audio/music/Bell_Note6_marimba.mp3"),
	7: create_audio_stream("res://assets/audio/music/Bell_Note7_marimba.mp3"),
	8: create_audio_stream("res://assets/audio/music/Bell_Note8_marimba.mp3"),
	9: create_audio_stream("res://assets/audio/music/Bell_Note9_marimba.mp3")
}

@onready var click_audio_streams = {
	1: create_audio_stream("res://assets/audio/sfx/pop.mp3"),
	2: create_audio_stream("res://assets/audio/sfx/place.mp3"),
	3: create_audio_stream("res://assets/audio/sfx/scribble.mp3")
}

@onready var ambience_player_a = $AmbiencePlayerA
@onready var ambience_player_b = $AmbiencePlayerB
@onready var school_bell_player = $SchoolBell
@onready var music_player = $MusicPlayer
@onready var sfx_player = $SFXPlayer

var active_ambience_player: AudioStreamPlayer
var crossfade_duration: float = 2.0

func _ready():
	
	for child in self.get_children():
		if child is AudioStreamPlayer:
			initial_volumes[child.name] = child.volume_db
			child.stop()
			
	# Connect signals for ambience crossfade
	ambience_player_a.finished.connect(_on_ambience_finished.bind(ambience_player_a))
	ambience_player_b.finished.connect(_on_ambience_finished.bind(ambience_player_b))

	active_ambience_player = ambience_player_a
	
	print(bell_audio_streams)
	
func _on_ambience_finished(finished_player: AudioStreamPlayer):
	var next_player = ambience_player_b if finished_player == ambience_player_a else ambience_player_a

	# Start crossfade
	next_player.volume_db = -80
	next_player.play()

	var tween = create_tween()
	tween.set_parallel(true)

	# Fade out current player
	tween.tween_property(finished_player, "volume_db", -80, crossfade_duration)
	# Fade in next player
	tween.tween_property(next_player, "volume_db", initial_volumes[ambience_player_a.name], crossfade_duration)

	active_ambience_player = next_player
	
func create_audio_stream(path: String) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.stream = load(path)
	add_child(player)
	return player
			
# Helper function to get the notes needed for a chain length
func get_notes_for_chain(chain_length: int) -> Array:
	var notes = []
	# Subtract 1 from chain length to skip the first student
	var actual_length = chain_length - 1
	var start_index = 9 - actual_length
	for i in range(start_index, 10):
		notes.append(bell_audio_streams[i])
	print("Notes array size: ", notes.size())
	return notes
	
func play_sfx(sound_type):
	#var random_key = randi() % place_audio_streams.size() + 1
	var sfx
	if sound_type == "pop":
		sfx = click_audio_streams[1]
	elif sound_type == "place":
		sfx = click_audio_streams[2]
	elif sound_type == "scribble":
		sfx = click_audio_streams[3]
	if sfx:
		sfx.play()
	
func play_school_bell():
	if school_bell_player.playing:
		return
	school_bell_player.volume_db = initial_volumes[school_bell_player.name]
	school_bell_player.play()
			
func play_ambience():
	if !ambience_player_a.playing and !ambience_player_b.playing:
		active_ambience_player = ambience_player_a
		active_ambience_player.volume_db = initial_volumes[ambience_player_a.name]
		active_ambience_player.play()
	
func play_music(note):
	print("playing note: ", note)
	note.volume_db = initial_volumes[note.name]
	note.play()
