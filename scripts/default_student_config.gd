extends Node
var level_config = {
	"crush": {
		"name": "Crush",
		"description": ["<3"],
		"rules": []
	},
	"quiet_kid": { 
		"name": "Alfie",
		"description": ["Won't sit next to a bully unless best_friend is there to support them."],
		"rules": [
			AdjacentRule.new({
				"cant_sit_next_to": ["bully_1", "bully_2"],
				"unless_adjacent": {"bully_1": ["best_friend"], "bully_2": ["best_friend"]}
			})
		]
	},
	"headphones": {
		"name": "Clara",
		"description": ["Listening to loud music. Can't pass the note to her from behind. Too hard to get her attention without making eye contact."],
		"rules": [
			AdjacentRule.new()
		]
	},
	"twin_1": {
		"name": "Yolanda",
		"description": ["The twins need to sit together. I don't know why. It's just a fact about them."],
		"rules": [
			AdjacentRule.new({
				"must_sit_next_to": ["twin_2"]
			})
		]
	},
	"best_friend": {
		"name": "Eugene",
		"description": ["My best friend. If he's not sitting next to me, he has to be the one to give the note to my crush."],
		"rules": [
			AdjacentRule.new({
				"must_sit_next_to": ["player", "crush"]
			})
		]
	},
	"twin_2": {
		"name": "Yellow",
		"description": ["The twins need to sit together. I don't know why. It's just a fact about them."],
		"rules": [
			AdjacentRule.new({
				"must_sit_next_to": ["twin_1"]
			})
		]
	},
	"bully_1": {
		"name": "Devin",
		"description": ["..."],
		"rules": [
			AdjacentRule.new()
		]
	},
	"bully_2": {
		"name": "Boris",
		"description": ["..."],
		"rules": [
			AdjacentRule.new()
		]
	}
}
