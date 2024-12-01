var level_config = {
	"classroom": [
		["player_male", "bully_02", "smelly", "empty"],
		["empty", "empty", "empty", "bully_01"],
		["empty", "empty", "empty", "empty"],
		["empty", "empty", "bff_female", "player_female"]
	],
	"friends": ["bff_male", "frog", "crying", "shakas", "headphones"],
	"student_configs": {
		"player_female": {
			"name": "Nina",
			"description": ["""Sophie's best friend. She's nice."""],
			"rules": []
		},
		"player_male": {
			"name": "Bobby",
			"description": ["""Sophie gave me this note in class yesterday. 
			
I can't believe she has a crush on me!"""],
			"rules": []
		},
		"bff_male": {
			"name": "Eugene",
			"description": ["""My best friend.

If he's not sitting next to me, he has to be the one to give the note to my crush."""],
			"rules": [
				AdjacentRule.new({
					"must_sit_next_to": ["player_male", "bff_female"],
					"cant_sit_next_to": ["smelly"]
				})
			]
		},
		"bff_female": { 
			"name": "Sophie",
			"description": ["""I've been trying to work up the courage to ask her out for ages."""],
			"rules": [
				AdjacentRule.new({
					"must_sit_next_to": ["player_female", "player_male"],
					"cant_sit_next_to": ["smelly"],
				})
			]
		},
		"shakas": {
			"name": "Alice",
			"description": ["""Pretty pissed off with Trent and Jayden for picking on Billy. 
			
She'll probably start a fight if she's sitting next to either of them, which I don't want."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["bully_01", "bully_02", "smelly"]
				})
			]
		},
		"twin_01": {
			"name": "Clarissa",
			"description": ["""Twin sister to Contessa. 
			
The twins have to sit together. Not totally sure why. It's just a fact about them."""],
			"rules": [
				AdjacentRule.new({
					"must_sit_next_to": ["twin_01"],
					"cant_sit_next_to": ["smelly"]
				})
			]
		},
		"twin_02": {
			"name": "Contessa",
			"description": ["""Twin sister to Clarissa. 
			
The twins have to sit together. Not totally sure why. It's just a fact about them."""],
			"rules": [
				AdjacentRule.new({
					"must_sit_next_to": ["twin_01"],
					"cant_sit_next_to": ["smelly"]
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
			
Unfortunately, that includes picking on Billy."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["smelly"]
				})
			]
		},
		"smelly": {
			"name": "Bronson",
			"description": ["""He reckons soap saps vital nutrients from the skin.

Most people aren't going to put up with sitting next to him. But Little Lilypad would probably see the flies and think, 'Free lunch.'"""],
			"rules": []
		},
		"frog": {
			"name": "Little Lilypad",
			"description": ["""Yeah, I'm not sure what to say about this guy."""],
			"rules": []
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
		"sick": {
			"name": "Albert",
			"description": ["""I don't know what's up with him, but he's always sick.
							
If I want his help, I should get it early, as he's probably going to head to sick bay soon. (Before step 3)"""],
			"rules": [
				SequenceRule.new({
					"order": {
						"chain_index": {
							3: Globals.Requirement.BEFORE
						}
					}
				}),
				AdjacentRule.new({
					"cant_sit_next_to": ["smelly"],
				})
			]
		},
		"crying": {
			"name": "Billy",
			"description": ["""Pretty sensitive. 
							
He won't sit next to anyone who might pick on him, unless he has Alice nearby to back him up."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["bully_01", "bully_02"],
					"unless_adjacent": {"bully_01": ["shakas"], "bully_02": ["shakas"]}
				})
			]
		}
	}
}
