extends Node

var debug_on = false

var game_over = false
var cursor = load("res://assets/sprites/cursor_V2.png")
var cursor_small = load("res://assets/sprites/cursor_V2_small.png")
var current_level : int = 1
var selected_student : Student
enum Direction { NORTH, SOUTH, EAST, WEST }
enum Requirement { BEFORE, AFTER }
var classroom = [
	["player", "empty", "empty", "bully_1"],
	["empty", "empty", "empty", "bully_2"],
	["empty", "twin_2", "empty", "empty"],
	["empty", "empty", "crush", "empty"]
]
var friends = ["headphones", "best_friend", "twin_1", "quiet_kid"]
var student_names = [
	"Alex",
	"Bella",
	"Charlie",
	"Diego",
	"Emma",
	"Felix",
	"Grace",
	"Hassan",
	"Isabel",
	"Jin",
	"Kai",
	"Lucia",
	"Marcus",
	"Nina",
	"Oliver",
	"Priya"
]
