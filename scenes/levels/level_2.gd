var level_config = {
	"classroom": [
		["player", "crush", "empty", "empty"],
		["empty", "empty", "empty", "empty"],
		["empty", "empty", "empty", "empty"],
		["empty", "empty", "empty", "empty"]
	],
	"friends": ["best_friend", "headphones", "twin_1", "wally"],
	"student_configs": {
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
				SequenceRule.new({
					"direction": {
						"cant_receive_from": [Globals.Direction.NORTH]
					}
				})
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
		"bff_male": {
			"name": "Eugene",
			"description": ["My best friend. If he's not sitting next to me, he has to be the one to give the note to my crush."],
			"rules": [
				AdjacentRule.new({
					"must_sit_next_to": ["player", "crush"]
				})
			]
		},
		"twin_02": {
			"name": "Yellow",
			"description": ["The twins need to sit together. I don't know why. It's just a fact about them."],
			"rules": [
				AdjacentRule.new({
					"must_sit_next_to": ["twin_1"]
				})
			]
		},
		"bully_01": {
			"name": "Devin",
			"description": ["..."],
			"rules": [
				AdjacentRule.new()
			]
		},
		"bully_02": {
			"name": "Boris",
			"description": ["..."],
			"rules": [
				AdjacentRule.new()
			]
		}
	}
}
