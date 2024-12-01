var level_config = {
	"classroom": [
		["player_female", "empty", "empty", "shakas"],
		["empty", "empty", "empty", "twin_02"],
		["empty", "bully_01", "empty", "bully_02"],
		["empty", "empty", "player_male", "bff_male"]
	],
	"friends": ["bff_female", "headphones", "twin_01", "crying"],
	"student_configs": {
		"player_female": {
			"name": "Nina",
			"description": ["""That's me!
			
My friends are going to help me pass this note to Bobby. I'm too nervous to tell him myself.
			
I just need to figure out where they should sit to make sure the note gets to him."""],
			"rules": []
		},
		"player_male": {
			"name": "Bobby",
			"description": ["""He's so cute."""],
			"rules": []
		},
		"crying": {
			"name": "Billy",
			"description": ["""Pretty sensitive. 
			
He won't sit next anyone who might pick on him, unless he has Alice nearby to back him up."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["bully_01", "bully_02"],
					"unless_adjacent": {"bully_01": ["bff_male"], "bully_02": ["bff_male"]}
				})
			]
		},
		"headphones": {
			"name": "Aabria",
			"description": ["""Always listening to loud music. 

Need to make eye contact to get her attention, so can't pass to her from behind."""],
			"rules": [
				SequenceRule.new({
					"direction": {
						"cant_receive_from": [Globals.Direction.NORTH]
					}
				})
			]
		},
		"twin_01": {
			"name": "Clarissa",
			"description": ["""Twin sister to Contessa. 
			
The twins have to sit together. Not totally sure why. It's just a fact about them."""],
			"rules": [
				AdjacentRule.new({
					"must_sit_next_to": ["twin_02"]
				})
			]
		},
		"twin_02": {
			"name": "Contessa",
			"description": ["""Twin sister to Clarissa. 
			
The twins have to sit together. Not totally sure why. It's just a fact about them."""],
			"rules": [
				AdjacentRule.new({
					"must_sit_next_to": ["twin_01"]
				})
			]
		},
		"bff_female": { 
			"name": "Sophie",
			"description": ["""My best friend.
							
If she's not sitting next to me, she has to be the one to give the note to Bobby."""],
			"rules": [
				AdjacentRule.new({
					"must_sit_next_to": ["player_male", "player_female"],
					"cant_sit_next_to": ["smelly"],
				})
			]
		},
		"bully_01": {
			"name": "Trent",
			"description": ["""Captain of the wrestling team (you can tell by the ears).
			
Trent and Brayden have been picking on Billy lately."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["smelly"]
				})
			]
		},
		"bully_02": {
			"name": "Brayden",
			"description": ["""Kind of just does whatever Trent does.
			
Unfortunately that includes picking on Billy."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["smelly"]
				})
			]
		},
	}
}
