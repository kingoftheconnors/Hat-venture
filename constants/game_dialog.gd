
class_name game_dialog

enum DIALOG_TYPE {
	SIGNAL_ACTION_1 = 0,
	TEMPLATE_1 = 1,
	TEMPLATE_2 = 2,
	DIVE_TUTORIAL = 3,
	SATELLITE = 4,
	GOTO_TUTORIAL = 5,
	GOTO_SHIP_FROM_OUTSIDE = 6,
	GOTO_WORLD_1 = 7,
	SHIP_SCREEN_1 = 8,
	SHIP_SCREEN_2 = 9,
	TIMMY_SHIP = 10,
	TIMMY_SHIP_YES = 11,
	TIMMY_SHIP_NO = 12,
	TIMMY_SHIP_2 = 13,
	TIMMY_SHIP_3_THANKS = 14,
	TIMMY_SHIP_3_RADICAL = 15,
	TIMMY_SHIP_VAULT = 16,
	LEVEL_1_CHASE_LILENS = 17,
	GOTO_BEDROOM = 18,
	GOTO_SHIP_FROM_BEDROOM = 19,
	BED = 20,
	CLOSET = 21,
	CHEST = 22,
	CHEST_YES = 23,
	CHEST_NO = 24,
	GOOD_MORNING_HATKID = 25,
	SHIP_DOOR_DIALOG_SELECTOR = 26,
	START_ROBOHEN_BOSS = 27,
	SPLASH_SCREEN = 28,
	FADEOUT_MUSIC = 29,
	ROBOHEN_DEFEATED = 30,
}

# Textbox Format:
#
# Textbox Style: Show box with name and text
# name: Speaker name. Shown on top left of dialog box
# text: Dialog text. Box will scroll to show entire text, regardless of size
#
# Signal Style: Emit signal to activate in-scene actions
# signal: Signal name. Must match a signal in the DialogStarter.gd file
# delay: Time to wait to appreciate signal's effects before continuing dialog
#

func get_dialog(text_num):
	match text_num:
		DIALOG_TYPE.TEMPLATE_1:
			return [
				{name = "You", text = "The future is now, thanks to dialog!"},
				{name = "Me", text = "Dialog is so amazing!"},
				{name = "You", text = "Indeed! Check out this SCIENCE!!"}
			]
		DIALOG_TYPE.TEMPLATE_2:
			return [
				{name = "Mustache Girl", text = "Hey you! Don't think I didn't see you stalking me!"},
				{name = "Mustache Girl", text = "Are you looking for your umbrella? I saw it land near the market area when you, you know."},
				{name = "Mustache Girl", text = "FELL FROM THE SKY!"},
				{name = "Mustache Girl", text = "Normally I'd question how you managed to fall that far, but I'm in a bit of a hurry."},
				{name = "Mustache Girl", text = "I've got a... party to set up!"},
				{name = "Hat Kid", text = "I'M NODDING AND SAYING NOTHING!"},
				#{signal = "action1", delay=0.25}
			]
		DIALOG_TYPE.DIVE_TUTORIAL:
			return [
				{disable_skipping = true},
				{name = "WARNING!", text = "To my subjects! Kids have been known to dive over large gaps using the " + OS.get_scancode_string(ggsManager.settings_data["13"].current.value) + " button!", unskippable = true},
				{name = "WARNING!", text = "If you don't know what " + OS.get_scancode_string(ggsManager.settings_data["13"].current.value) + " buttons are, call up your radical overlord!", unskippable = true},
				{name = "...", text = "*A messy sketch of a kid and a bird is scrawled into the sign*", unskippable = true},
				{enable_skipping = true}
			]
		DIALOG_TYPE.SATELLITE:
			return [
				{name = "", text = "Satellite realigned!"},
				{settag = "satellite_aligned", value = true},
			]
		DIALOG_TYPE.GOTO_TUTORIAL:
			return [
				{sound = sound_system.SFX.DOOR},
				{level = "res://level-select/tutorial.tscn"}
			]
		DIALOG_TYPE.GOTO_SHIP_FROM_OUTSIDE:
			return [
				{sound = sound_system.SFX.DOOR},
				{level = "res://level-select/ship.tscn", spawn_point = 2}
			]
		DIALOG_TYPE.GOTO_WORLD_1:
			return [
				{sound = sound_system.SFX.DOOR},
				{level = "res://world1/level1.tscn"}
			]
		DIALOG_TYPE.SIGNAL_ACTION_1:
			return [
				{signal = "action1", unskippable = true}
			]
		DIALOG_TYPE.SHIP_SCREEN_1:
			return [
				{disable_skipping = true},
				# Bounce player back
				{signal = "action7", delay=0.5},
				{name = "ERROR", text = "SATELLITE NOT PROPERLY CONFIGURED."},
				{name = "ERROR", text = "PLEASE RECONFIGURE THE SATELLITE MANUALLY."},
				# Move camera
				{signal = "action2", delay=1, if_tag_false = "screen_seen_1", unskippable = true},
				# Unlatch door
				{signal = "action3", delay=0.5, if_tag_false = "screen_seen_1", unskippable = true},
				# Reset camera
				{signal = "action6", delay=1, if_tag_false = "screen_seen_1", unskippable = true},
				{signal = "action4", if_tag_false = "screen_seen_1", unskippable = true},
				# Hide display (showing only exclamation point)
				{signal = "action5", unskippable = true},
				{settag = "screen_seen_1", value = true},
				{enable_skipping = true}
			]
		DIALOG_TYPE.SHIP_SCREEN_2:
			return [
				{disable_skipping = true},
				# Bounce player back
				{signal = "action7", delay=1},
				{name = "SHIP", text = "All systems operational. Hello master!"},
				{fadeout_music_fast = true, if_tag_false = "screen_seen_2"},
				{sound = sound_system.SFX.KNOCK, if_tag_false = "screen_seen_2"},
				{signal = "action8", delay=1, unskippable = true},
				# Move camera
				{signal = "action2", delay=1, if_tag_false = "screen_seen_2", unskippable = true},
				{sound = sound_system.SFX.KNOCK, if_tag_false = "screen_seen_2"},
				# Reset camera
				{signal = "action6", delay=1, if_tag_false = "screen_seen_2", unskippable = true},
				{signal = "action4", if_tag_false = "screen_seen_2", unskippable = true},
				# Start looping knock sound
				{signal = "action9", unskippable = true},
				{settag = "screen_seen_2", value = true},
				{enable_skipping = true}
			]
		DIALOG_TYPE.TIMMY_SHIP:
			return [
				{signal = "actionN"},
				{music = sound_system.MUSIC.TIMMY, delay=1.5},
				{signal = "action1", delay=5.25},
				{signal = "actionM", delay=.5},
				# Start dialog options
				{animate2 = "talk"},
				{name = "Kid", text = "Yo! You look like a new face!"},
				{name = "Timmy", text = "My name's Timmy, and I'm the ruler of this world that you ended up on!"},
				{animate2 = "idle"},
				{name = "Timmy", text = "Mind if I drop in?", options = {"YES": DIALOG_TYPE.TIMMY_SHIP_YES, "NO": DIALOG_TYPE.TIMMY_SHIP_NO}},
			]
		DIALOG_TYPE.TIMMY_SHIP_YES:
			return [
				{animate2 = "talk"},
				{name = "Timmy", text = "Tubular!"},
				{animate2 = "idle"},
				{queue = DIALOG_TYPE.TIMMY_SHIP_2},
			]
		DIALOG_TYPE.TIMMY_SHIP_NO:
			return [
				{animate2 = "sass"},
				{name = "Timmy", text = "Ok, but I know you meant to say yes."},
				{animate2 = "idle"},
				{queue = DIALOG_TYPE.TIMMY_SHIP_2},
			]
		DIALOG_TYPE.TIMMY_SHIP_2:
			return [
				# Move Timmy to the left and have him look around
				{signal = "action2", delay=1},
				{animate2 = "talk"},
				{name = "Timmy", text = "Whoa!! This is your place?"},
				{animate2 = "idle"},
				{signal = "actionL", delay=0.3},
				{name = "Timmy", text = "It looks radical, man!!", options = {"THANKS!": DIALOG_TYPE.TIMMY_SHIP_3_THANKS, "RADICAL?": DIALOG_TYPE.TIMMY_SHIP_3_RADICAL}}
			]
		DIALOG_TYPE.TIMMY_SHIP_3_THANKS:
			return [
				{animate2 = "talk"},
				{name = "Timmy", text = "Hey, no sweat! I'm just speaking the facts."},
				{queue = DIALOG_TYPE.TIMMY_SHIP_VAULT}
			]
		DIALOG_TYPE.TIMMY_SHIP_3_RADICAL:
			return [
				{animate2 = "talk"},
				{name = "Timmy", text = "What? You've never heard anyone say 'radical' before?"},
				{animate2 = "sass"},
				{name = "Timmy", text = "That's insulting, man. I'm gonna pretend I didn't hear that."},
				{queue = DIALOG_TYPE.TIMMY_SHIP_VAULT}
			]
		DIALOG_TYPE.TIMMY_SHIP_VAULT:
			return [
				{animate2 = "talk"},
				{name = "Timmy", text = "One question, though."},
				{animate2 = "idle"},
				# Pan over to time vault sequence
				{signal = "action3", delay=1},
				{animate2 = "talk"}, # TODO: Float
				{name = "Timmy", text = "What's that big vault?"},
				# Walk to Time Piece
				{signal = "action4"},
				{animate2 = "float", delay=1.5},
				{signal = "action5", delay=.5},
				{signal = "actionM", delay=.5},
				{animate2 = "talk"},
				{name = "Timmy", text = "Looks kinda important... what do ya keep in here, anyway?"},
				{animate2 = "idle"},
				{animate1 = "talk", delay=1},
				{animate1 = "idle"},
				{animate2 = "surprise"},
				{name = "Timmy", text = "Woah! Time Pieces??"},
				{animate2 = "talk"},
				{name = "Timmy", text = "I've heard so much about these! And you have a whole vault of them!?"},
				{animate2 = "sass"},
				{name = "Timmy", text = "I wanna have a peek!"},
				# Psychic pose + Shake Vault + Delay 1
				{animate2 = "open_vault"},
				{signal = "actionO", delay=1},
				# Vault blasts open and hat falls forward
				{signal = "actionP", delay=1},
				# Timmy Flies up
				{animate2 = "fly"},
				{signal = "actionJ", delay=1},
				# Animate Timmy holding Time piece
				{animate2 = "hold_fly"},
				{name = "Timmy", text = "Woahhhh.... sparkly."},
				# Hat Kid jumps up and faces right
				{signal = "actionQ"},
				# TODO: Start tossing it in one hand
				{name = "Timmy", text = "You know what I heard? I heard these pieces let you travel time!"},
				{name = "Timmy", text = "Think of what you could do with even one of these..."},
				# TODO: Some other Timmy animation
				{name = "Timmy", text = "...you could have an infinite flapjack breakfast if you wanted to!"},
				{delay=0.6},
				{fadeout_music = true, delay=0.4},
				# Look at Hat
				{animate2 = "idle"},
				{animate2 = "talk"},
				{signal = "actionK", delay=0.1},
				{name = "Timmy", text = "What? You've never seen someone use psychic powers before?"},
				{animate2 = "idle"},
				# Bounce Hat Kid towards Timmy, bounce Timmy away, holding back the TimePiece
				{signal = "actionG", delay=0.1},
				{signal = "actionH", delay=0.75},
				{animate2 = "sass"},
				{name = "Timmy", text = "Yo, what's the rush? You got a hot date with this Piece or something?"},
				{name = "Timmy", text = "I'll take as much time as I wanna! Buzz off!"},
				{animate2 = "idle"},
				# Bounce Hat Kid towards Timmy
				{signal = "actionG", delay=0.075},
				{signal = "actionH", delay=0.1},
				# Timmy lifts up Hat up
				{signal = "action6", delay=0.2},
				{animate2 = "psychic"},
				{name = "Timmy", text = "Hey! Didn't your mom ever teach you that 'sharing is caring?'"},
				{animate2 = "sass"},
				{name = "Timmy", text = "If you're gonna be greedy, then I'll just steal all of them!"},
				{animate2 = "psychic"},
				# Camera release and throw
				# Animate hat kid hurt animation
				{animate1 = "hurt_basic"},
				{signal = "action7", delay=2},
				{signal = "actionR"},
				{animate2 = "sass"},
				{name = "Timmy", text = "Alright Lil'ens! Come on in!"},
				{animate2 = "idle"},
				# Screen shake
				{signal = "actionE", delay=2},
				# Lil'ens enter and walk to vault
				{music = sound_system.MUSIC.TIMMY_STRIKES},
				{signal = "actionS"},
				{signal = "action9", delay=2},
				# Dust cloud
				{signal = "actionF", delay=3},
				# Walk Eltuns (now carrying timepieces) to door and Timmy towards Hat Kid
				{signal = "actionA", delay=2},
				# Say words
				{animate2 = "sass"},
				{name = "Timmy", text = "Keeping all these Time Pieces to yourself is mondo uncool."},
				{name = "Timmy", text = "So as the ruler of this world, I'll take them off your hands! It's only fair for trespassing."},
				{name = "Timmy", text = "Smell ya later stinky!"},
				# Timmy Leave
				{signal = "actionB"},
				{name = "Timmy", text = "Hahahahahahahahahaha!!"},
				{fadeout_music = true},
				{delay=2},
				# Hat Kid Jump up
				{signal = "actionC", delay=1},
				# Hat Kid walk towards door
				{signal = "actionD", delay=4},
				# Goto 1
				{sound = sound_system.SFX.DOOR},
				{level = "res://world1/level1.tscn"}
			]
		DIALOG_TYPE.LEVEL_1_CHASE_LILENS:
			return [
				{disable_skipping = true},
				{signal = "action1", if_tag_false = "chased_lilens", unskippable = true},
				{signal = "action2", delay=5, if_tag_false = "chased_lilens", unskippable = true},
				{signal = "action3", delay=2, if_tag_false = "chased_lilens", unskippable = true},
				{settag = "chased_lilens", value = true},
				{enable_skipping = true},
			]
		DIALOG_TYPE.GOTO_BEDROOM:
			return [
				{sound = sound_system.SFX.DOOR},
				{level = "res://level-select/bedroom.tscn", spawn_point = 2}
			]
		DIALOG_TYPE.GOTO_SHIP_FROM_BEDROOM:
			return [
				{sound = sound_system.SFX.DOOR},
				{level = "res://level-select/ship.tscn", spawn_point = 3}
			]
		DIALOG_TYPE.BED:
			return [
				{name = "XD", text = "Your bed. It's very comfy!"},
				{name = ":T", text = "Unfortunately, there’s exploring to do. No time for sleeping!"},
			]
		DIALOG_TYPE.CLOSET:
			return [
				{name = ":]", text = "A closet! You only wear one outfit, so there’s plenty of room for skeletons."},
			]
		DIALOG_TYPE.CHEST:
			return [
				{name = ":o", text = "It's a chest. Open it?", options = {"YES": DIALOG_TYPE.CHEST_YES, "NO": DIALOG_TYPE.CHEST_NO}}
			]
		DIALOG_TYPE.CHEST_YES:
			return [
				{name = ":D", text = "There’s a few stuffed animals you keep based on people you’ve met in the past."},
				{name = ":T", text = "You’re a big fan of the noodle-y fellow, but you’ve never met someone like that before..."},
				{name = ":D", text = "Regardless, there’s also a pon in here!", if_tag_false = "get_chest_pon"},
				{addpon = 1},
				{sound = sound_system.SFX.COLLECT},
				{settag = "get_chest_pon", value = true},
			]
		DIALOG_TYPE.CHEST_NO:
			return [
				{name = ":X", text = "You decide to keep the chest’s contents a secret."},
			]
		DIALOG_TYPE.GOOD_MORNING_HATKID:
			return [
				# TODO: Lullaby song?
				# Teleport
				{signal = "action1", unskippable = true},
				{music = sound_system.MUSIC.NEW_VENTURE, fadein = sound_system.FADEIN_SPEED.SLOW, unskippable = true},
				# Start sleeping animations
				{animate1 = "sleep"},
				{animate2 = "sleep"},
				# Wait for screen brightness to fade in completely so brightness setting doesn't get overriden
				{delay = 3, unskippable = true},
				{delay = 10.84},
				# Start JUMP animation
				{brightness = 0, unskippable = true},
				{delay = 0.1},
				{signal = "actionJ"},
				# TODO: Sound effect waking Hat Kid up
				# Start speaker (TODO: SLOW TEXT DOWN ON "GOOOOOOD")
				{name = "Speaker", text = "Goooood morning! And welcome to yet another day of adventure!!", autoscroll = true},
				{name = "Speaker", text = "You are currently situated in: GRASSY-LANDS. All systems are operational!", autoscroll = true},
				# Hat Kid stands up
				# TODO: Wait for Hat Kid's condition "not_jumping" to be true and hat to be on Hat Kid
				{delaytil_animate2_method_true = "is_hat_fall_finished"},
				{animate2 = "invisible"},
				{signal = "actionK"},
				{name = "Speaker", text = "Today’s to-do list includes: waking up, adjusting to your surroundings, and exploring!", autoscroll = true},
				{animate1 = "idle", unskippable = true},
				{animate2 = "invisible", unskippable = true},
				{settag = "goodmorning_complete", value = true},
			]
		DIALOG_TYPE.SHIP_DOOR_DIALOG_SELECTOR:
			return [
				{queue = DIALOG_TYPE.GOTO_TUTORIAL, if_tag_false = "screen_seen_2", skippable = true},
				{queue = DIALOG_TYPE.TIMMY_SHIP, if_tag_true = "screen_seen_2", skippable = true},
				{queue = DIALOG_TYPE.GOTO_TUTORIAL, if_skipping_on = true, if_tag_false = "satellite_aligned"},
				{queue = DIALOG_TYPE.TIMMY_SHIP, if_skipping_on = true, if_tag_true = "satellite_aligned"},
			]
		DIALOG_TYPE.START_ROBOHEN_BOSS:
			return [
				# TO ADD: Timmy and Kurt jumping into machine. Later textboxes are unskippable
				# in case player chooses to start skip during those text boxes (which don't exist yet)
				{disable_skipping = true},
				{delay = 1, unskippable = true},
				{fadeout_music_fast = true, delay=.5, unskippable = true},
				{music = sound_system.MUSIC.BOSS_1, unskippable = true},
				{signal = "action2", delay = 0.5, unskippable = true},
				{signal = "action1", delay = 4, unskippable = true},
				{enable_skipping = true},
			]
		DIALOG_TYPE.SPLASH_SCREEN:
			return [
				{delay = 2},
				{level = "res://title-screen/title-screen.tscn"}
			]
		DIALOG_TYPE.FADEOUT_MUSIC:
			return [
				{fadeout_music_fast = true, delay=.5},
			]
		DIALOG_TYPE.ROBOHEN_DEFEATED:
			return [
				{disable_skipping = true},
				{signal = "action1", delay = 2.5, unskippable = true}, # Move timepiece to Robohen
				{signal = "action2", delay = 2, unskippable = true}, # Fly timepiece to goal
				{enable_skipping = true},
			]
