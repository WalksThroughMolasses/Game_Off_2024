var level_config = {
	"classroom": [
		["bully_01", "empty", "empty", "empty"],
		["player_male", "empty", "empty", "empty"],
		["twin_01", "twin_02", "smelly", "empty"],
		["empty", "empty", "empty", "player_female"]
	],
	"friends": ["sleepy", "musician", "sick", "poser", "frog", "crying"],
	"student_configs": {
		"player_female": {
			"name": "Nina",
			"description": ["""<3"""],
			"rules": []
		},
		"player_male": {
			"name": "Bobby",
			"description": ["""<3"""],
			"rules": []
		},
		"poser": {
			"name": "Ivana",
			"description": ["""Won't sit with the twins."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["twin_01", "twin_02", "smelly"],
				})
			]
		},
		"bff_male": {
			"name": "Eugene",
			"description": ["""My best friend.

If he's not sitting next to me, he has to be the one to give the note to Nina."""],
			"rules": [
				AdjacentRule.new({
					"must_sit_next_to": ["player_male", "player_female"],
					"cant_sit_next_to": ["smelly"]
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
		"shakas": {
			"name": "Alice",
			"description": ["""Pretty pissed off with Trent and Jayden for picking on Billy. 
			
She'll probably start a fight if she's sitting next to either of them, which I don't want."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["bully_01", "bully_02", "smelly", "furry"]
				})
			]
		},
		"posh": { 
			"name": "Eleanor",
			"description": ["""She won't help until she finishes her tea. (After turn 2)"""],
			"rules": [
				SequenceRule.new({
					"order": {
						"chain_index": {
							3: Globals.Requirement.AFTER
						}
					}
				})
			]
		},
		"furry": {
			"name": "Dylan",
			"description": ["""Alice and Alfonso won't sit next to him, because they're allergic to cats.
							
It's unclear if Dylan just happens to own a cat... or if his costume is somehow made of real cat hair."""],
			"rules": [
			]
		},
		"musician": { 
			"name": "Xavier",
			"description": ["""Plays a [s]trumpet[/s] [s]trombone[/s] [s]french horn[/s] brass instrument of some kind in the concert band.

He's always practising his scales in class. Ms. Moore hates it, but she can't stop him.

Won't sit next to Ivana after she tipped yoghurt in his horn."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["smelly", "poser"],
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
					"can't_sit_next_to": ["smelly"]
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
					"can't_sit_next_to": ["smelly"]
				})
			]
		},
		"photographer": {
			"name": "Alfonso",
			"description": ["""Only agreed to help if he can sit next to Little Lilypad, so he can take a picture for National Geographic."""],
			"rules": [
				AdjacentRule.new({
					"must_sit_next_to": ["frog"],
					"cant_sit_next_to": ["furry, smelly"]
				})
			]
		},
		"bully_01": {
			"name": "Trent",
			"description": ["""Trent's softened up a bit. 
			
Billy still refuses to sit next to him. But he'll back up any one else that Brayden picks on."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["smelly"]
				})
			]
		},
		"bully_02": {
			"name": "Brayden",
			"description": ["""Trent and Brayden have been picking on Billy lately."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["smelly"]
				})
			]
		},
		"sleepy": {
			"name": "Tala",
			"description": [""""Honk shoo, honk shoo" - Tala in Math class, 2024

I'd have to wake her up to get any help from her. No easy feat."""],
			"rules": [
				AdjacentRule.new({
					"must_sit_next_to": ["musician"],
				})
			]
		},
		"smelly": {
			"name": "Bronson",
			"description": ["""He reckons soap saps vital nutrients from the skin.

Most people aren't going to put up with sitting next to him... But Little Lilypad would probably see the flies and think free lunch."""],
			"rules": []
		},
		"frog": {
			"name": "Little Lilypad",
			"description": ["""Yeah, I'm not sure what to say about this guy."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["bully_02"],
					"unless_adjacent": {"bully_02": ["bully_01"]}
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
				}),
				AdjacentRule.new({
					"cant_sit_next_to": ["smelly"],
				})
			]
		},
		"sick": {
			"name": "Albert",
			"description": ["""I don't know what's up with him, but he's always sick.
							
If I want his help, I should get it early, as he's probably going to head to sick bay soon. (Before turn 3)"""],
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
							
He won't sit next anyone who might pick on him, unless he has Alice nearby to back him up."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["bully_01", "bully_02", "smelly"],
					"unless_adjacent": {"bully_01": ["shakas"], "bully_02": ["shakas"]}
				})
			]
		}
	}
}
