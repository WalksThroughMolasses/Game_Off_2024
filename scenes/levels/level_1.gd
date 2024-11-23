var level_config = {
	"crush": {
		"name": "Crush",
		"position": Vector2i(-1, -1),
		"is_moveable": true,
		"description": ["<3"],
		"rules": []
	},
	"quiet_kid": {
		"name": "Alfie",
		"position": Vector2i(-1, -1),
		"is_moveable": true,
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
		"position": Vector2i(-1, -1),
		"is_moveable": true,
		"description": ["Listening to loud music. Can't pass the note to her from behind. Too hard to get her attention without making eye contact."],
		"rules": [
			AdjacentRule.new()
		]
	},
	"twin_1": {
		"name": "Yolanda",
		"position": Vector2i(-1, -1),
		"is_moveable": true,
		"description": ["The twins need to sit together. I don't know why. It's just a fact about them."],
		"rules": [
			AdjacentRule.new({
				"must_sit_next_to": ["twin_2"]
			})
		]
	},
	"best_friend": {
		"name": "Eugene",
		"position": Vector2i(-1, -1),
		"is_moveable": true,
		"description": ["My best friend. If he's not sitting next to me, he has to be the one to give the note to my crush."],
		"rules": [
			AdjacentRule.new({
				"must_sit_next_to": ["player", "crush"]
			})
		]
	},
	"twin_2": {
		"name": "Yellow",
		"position": Vector2i(1, 1),
		"is_moveable": true,
		"description": ["The twins need to sit together. I don't know why. It's just a fact about them."],
		"rules": [
			AdjacentRule.new({
				"must_sit_next_to": ["twin_1"]
			})
		]
	},
	"bully_1": {
		"name": "Devin",
		"position": Vector2i(3, 1),
		"is_moveable": true,
		"description": ["..."],
		"rules": [
			AdjacentRule.new()
		]
	},
	"bully_2": {
		"name": "Boris",
		"position": Vector2i(3, 2),
		"is_moveable": true,
		"description": ["..."],
		"rules": [
			AdjacentRule.new()
		]
	}
}
