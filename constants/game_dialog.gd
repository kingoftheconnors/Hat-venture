
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
	START_ROBOHEN_BOSS = 27
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
				{name = "WARNING!", text = "To my subjects! Kids have been known to dive over large gaps using the " + OS.get_scancode_string(ggsManager.settings_data["13"].current.value) + " button!"},
				{name = "WARNING!", text = "If you don't know what " + OS.get_scancode_string(ggsManager.settings_data["13"].current.value) + " buttons are, call up your radical overlord!"},
				{name = "...", text = "*A messy sketch of a kid and a bird is scrawled into the sign*"}
			]
		DIALOG_TYPE.SATELLITE:
			return [
				{name = "", text = "Satellite realigned!"},
				{settag = "satellite_aligned", value = true},
			]
		DIALOG_TYPE.GOTO_TUTORIAL:
			return [
				{level = "res://level-select/tutorial.tscn"}
			]
		DIALOG_TYPE.GOTO_SHIP_FROM_OUTSIDE:
			return [
				{level = "res://level-select/ship.tscn", spawn_point = 2}
			]
		DIALOG_TYPE.GOTO_WORLD_1:
			return [
				{level = "res://world1/level1.tscn"}
			]
		DIALOG_TYPE.SIGNAL_ACTION_1:
			return [
				{signal = "action1"}
			]
		DIALOG_TYPE.SHIP_SCREEN_1:
			return [
				# Bounce player back
				{signal = "action7", delay=0.5},
				{name = "ERROR", text = "SATELLITE NOT PROPERLY CONFIGURED."},
				{name = "ERROR", text = "PLEASE RECONFIGURE THE SATELLITE MANUALLY."},
				# Move camera
				{signal = "action2", delay=1, if_tag_false = "screen_seen_1"},
				# Unlatch door
				{signal = "action3", delay=0.5, if_tag_false = "screen_seen_1"}, # TODO: unlatch SFX
				# Reset camera
				{signal = "action6", delay=1, if_tag_false = "screen_seen_1"},
				{signal = "action4", if_tag_false = "screen_seen_1", unskippable = true},
				# Hide display (showing only exclamation point)
				{signal = "action5"},
				{settag = "screen_seen_1", value = true},
			]
		DIALOG_TYPE.SHIP_SCREEN_2:
			return [
				# Bounce player back
				{signal = "action7", delay=1},
				{name = "SHIP", text = "All systems operational. Hello master!"},
				# TODO: Enable knock sfx
				#{signal = "action8", delay=1},
				# Move camera
				{signal = "action2", delay=1, if_tag_false = "screen_seen_2"},
				# Reset camera
				{signal = "action6", delay=1, if_tag_false = "screen_seen_2"},
				{signal = "action4", if_tag_false = "screen_seen_2", unskippable = true},
				{settag = "screen_seen_2", value = true},
			]
		DIALOG_TYPE.TIMMY_SHIP:
			return [
				{signal = "actionN", delay=1.75},
				{fadeout_music_fast = true, delay=.5},
				{music = sound_system.MUSIC.TIMMY},
				{signal = "action1", delay=4.5},
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
				{name = "Timmy", text = "Okay, but I know you meant to say yes!"},
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
				{name = "Timmy", text = "What's that?"},
				# Walk to Time Piece
				{signal = "action4"},
				{animate2 = "float", delay=1.5},
				{signal = "action5", delay=.5},
				{signal = "actionM", delay=.5},
				{animate2 = "talk"},
				{name = "Timmy", text = "Looks like some kinda big vault... what do ya keep in here, anyway?"},
				{animate2 = "idle"},
				{animate1 = "talk", delay=1},
				{animate1 = "idle"},
				{animate2 = "surprise"},
				{name = "Timmy", text = "Woah! Time Pieces??"},
				{animate2 = "talk"},
				{name = "Timmy", text = "I've heard so much about these! And you have a whole vault of them!?"},
				{animate2 = "sass"},
				{name = "Timmy", text = "I wanna have a peek!"},
				{animate2 = "psychic", delay=0.5},
				# TODO: Open up vault and hat kid flies backward
				{animate2 = "fly"},
				{signal = "actionJ", delay=1},
				# TODO: Float a timepiece to Timmy
				{name = "Timmy", text = "Woahhhh.... sparkly."},
				# TODO: Start tossing it in one hand
				{name = "Timmy", text = "You know what I heard? I heard these pieces let you travel time!"},
				{name = "Timmy", text = "Think of what you could do with even one of these..."},
				# TODO: Some other Timmy animation
				{name = "Timmy", text = "...you could have an infinite flapjack breakfast if you wanted to!"},
				{delay=1},
				# Look at Hat
				{animate2 = "idle"},
				{signal = "actionK", delay=0.1},
				{animate2 = "talk"},
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
				{animate2 = "sass"},
				{name = "Timmy", text = "Alright Lil'ens! Come on in!"},
				{animate2 = "idle"},
				# Screen shake
				{signal = "actionE", delay=1},
				# Lil'ens enter and walk to vault
				{signal = "action9", delay=2},
				# Dust cloud
				{signal = "actionF", delay=3},
				# Turn off dust cloud and walk Eltuns (now carrying timepieces) to door
				# Move Timmy towards door
				{signal = "actionA", delay=2.5},
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
				{signal = "actionD", delay=0.5},
				# Goto 1
				{level = "res://world1/level1.tscn"}
			]
		DIALOG_TYPE.LEVEL_1_CHASE_LILENS:
			return [
				{disable_skipping = true},
				{signal = "action1", if_tag_false = "chased_lilens"},
				{signal = "action2", delay=5, if_tag_false = "chased_lilens"},
				{signal = "action3", delay=2, if_tag_false = "chased_lilens"},
				{enable_skipping = true},
				{settag = "chased_lilens", value = true},
			]
		DIALOG_TYPE.GOTO_BEDROOM:
			return [
				{level = "res://level-select/bedroom.tscn", spawn_point = 2}
			]
		DIALOG_TYPE.GOTO_SHIP_FROM_BEDROOM:
			return [
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
				{signal = "action1", if_tag_false = "goodmorning_complete"},
				# Start sleeping animations
				{animate1 = "sleep", if_tag_false = "goodmorning_complete"},
				{animate2 = "sleep", if_tag_false = "goodmorning_complete"},
				# Brightness
				{brightness = -1, delay = 5, if_tag_false = "goodmorning_complete"},
				# Start JUMP animation
				{brightness = 0, if_tag_false = "goodmorning_complete"},
				{signal = "actionJ", if_tag_false = "goodmorning_complete"},
				# TODO: Sound effect waking Hat Kid up
				# Start speaker (TODO: SLOW TEXT DOWN ON "GOOOOOOD")
				{music = sound_system.MUSIC.SHIP},
				{name = "Speaker", text = "Goooood morning! And welcome to yet another day of adventure!!", if_tag_false = "goodmorning_complete", autoscroll = true},
				{name = "Speaker", text = "You are currently situated in: GRASSY-LANDS. All systems are operational!", if_tag_false = "goodmorning_complete", autoscroll = true},
				# Hat Kid stands up
				# TODO: Wait for Hat Kid's condition "not_jumping" to be true and hat to be on Hat Kid
				{delaytil_animate2_method_true = "is_hat_fall_finished", if_tag_false = "goodmorning_complete"},
				{animate2 = "invisible", if_tag_false = "goodmorning_complete"},
				{signal = "actionK", if_tag_false = "goodmorning_complete"},
				#{animate1 = "get_up", if_tag_false = "goodmorning_complete"},
				{name = "Speaker", text = "Today’s to-do list includes: waking up, adjusting to your surroundings, and exploring!", if_tag_false = "goodmorning_complete", autoscroll = true},
				{animate1 = "idle", if_tag_false = "goodmorning_complete", unskippable = true},
				{animate2 = "invisible", if_tag_false = "goodmorning_complete", unskippable = true},
				{settag = "goodmorning_complete", value = true},
			]
		DIALOG_TYPE.SHIP_DOOR_DIALOG_SELECTOR:
			return [
				{queue = DIALOG_TYPE.GOTO_TUTORIAL, if_tag_false = "screen_seen_2"},
				{queue = DIALOG_TYPE.TIMMY_SHIP, if_tag_true = "screen_seen_2"}
			]
		DIALOG_TYPE.START_ROBOHEN_BOSS:
			return [
				{delay = 1},
				{signal = "action2", delay = 0.5},
				{signal = "action1", delay = 4},
			]
