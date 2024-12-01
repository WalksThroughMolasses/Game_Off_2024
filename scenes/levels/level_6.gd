var level_config = {
	"classroom": [
		["player_female", "empty", "empty", "empty"],
		["sleepy", "bully_01", "twin_01", "empty"],
		["empty", "empty", "empty", "empty"],
		["bff_female", "empty", "poser", "smelly"]
	],
	"friends": ["posh", "twin_02", "shakas", "bully_02", "frog", "furry", "sick", "crying"],
	"student_configs": {
		"player_female": {
			"name": "Nina",
			"description": ["""She deserves better than him."""],
			"rules": []
		},
		"player_male": {
			"name": "Bobby",
			"description": ["""I don't understand why he'd do that to her."""],
			"rules": []
		},
		"poser": {
			"name": "Ivana",
			"description": ["""Bit of a poser, honestly.
			
She wouldn't be caught dead sitting with the twins. Her words, not mine!"""],
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
			"description": ["""I hate to see Bobby break Nina's heart like that. 
			
Doesn't she know she has someone who really cares about her?"""],
			"rules": [
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
			"description": ["""Captain of the debate team, rowing team, croquet team and etiquette team.
			
She won't help until she finishes her tea. (After step 3)"""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["smelly"],
				}),
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
			"description": ["""Alice and Alfonso won't sit next to them, because they are both allergic to cats.

It's unclear if Dylan just happens to own a cat... or if their costume is somehow made of real cat hair."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["smelly", "bully_01", "bully_02"],
				}),
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
					"must_sit_next_to": ["twin_02"],
					"cant_sit_next_to": ["smelly", "poser"]
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
					"cant_sit_next_to": ["smelly", "poser"]
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
			"description": ["""Captain of the wrestling team.
			
Trent's softened up a bit. Billy still refuses to sit next to him, but he'll back up any one else that Brayden picks on."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["smelly"]
				})
			]
		},
		"bully_02": {
			"name": "Brayden",
			"description": ["""Brayden's finally doing his own thing now.
			
Unfortunately, that includes picking on Little Lilypad."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["smelly"]
				})
			]
		},
		"sleepy": {
			"name": "Tala",
			"description": [""""Honk shoo, honk shoo." - Tala in Math class, 2024

I'd have to wake her up to get any help from her. No easy feat."""],
			"rules": [
				AdjacentRule.new({
					"must_sit_next_to": ["musician"],
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
			"description": ["""Yeah, I'm not sure what to say about this guy.
			
Trent's being nice to him now, but Jayden still wants to steal his lilypad."""],
			"rules": [
				AdjacentRule.new({
					"cant_sit_next_to": ["bully_02"]
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
					"cant_sit_next_to": ["bully_01", "bully_02", "smelly"],
					"unless_adjacent": {"bully_01": ["shakas"], "bully_02": ["shakas"]}
				})
			]
		}
	}
}
