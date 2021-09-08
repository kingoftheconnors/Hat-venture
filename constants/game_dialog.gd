
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
				#{name = "WARNING!", text = "Kids have been known to dive over large gaps using the " + OptionsMenu.get_keyname("ui_B") + " button!"},
				#{name = "WARNING!", text = "If you don't know what " + OptionsMenu.get_keyname("ui_B") + " buttons are, call up your radical overlord: Me!"},
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
				{signal = "action2", delay=1},
				# Unlatch door
				{signal = "action3", delay=0.5}, # TODO: unlatch SFX
				# Reset camera
				{signal = "action4", delay=0.75},
				# Hide display (showing only exclamation point)
				{signal = "action5"},
			]
		DIALOG_TYPE.SHIP_SCREEN_2:
			return [
				# Bounce player back
				{signal = "action7", delay=1},
				{name = "SHIP", text = "All systems operational. Hello master!"},
				# Activate Timmy door action (TODO: Enable knock sfx)
				{signal = "action8", delay=1},
				# Move camera
				{signal = "action2", delay=1},
				# Reset camera
				{signal = "action4", delay=0.75},
			]
		DIALOG_TYPE.TIMMY_SHIP:
			return [
				# TODO: Show Timmy and sfx (door becomes open black void)
				{signal = "action1", delay=1},
				# Start dialog options
				{name = "Kid", text = "Yo! You look like a new face!"},
				{name = "Timmy", text = "My name's Timmy, and I'm the ruler of this world that you ended up on!"},
				{name = "Timmy", text = "Mind if I drop in?", options = {"YES": DIALOG_TYPE.TIMMY_SHIP_YES, "NO": DIALOG_TYPE.TIMMY_SHIP_NO}},
			]
		DIALOG_TYPE.TIMMY_SHIP_YES:
			return [
				{name = "Timmy", text = "Tubular!"},
				{queue = DIALOG_TYPE.TIMMY_SHIP_2},
			]
		DIALOG_TYPE.TIMMY_SHIP_NO:
			return [
				{name = "Timmy", text = "Okay, but I know you meant yes!"},
				{queue = DIALOG_TYPE.TIMMY_SHIP_2},
			]
		DIALOG_TYPE.TIMMY_SHIP_2:
			return [
				# Move Timmy to the left and have him look around
				{signal = "action2", delay=1},
				{name = "Timmy", text = "Whoa!! This is your place?"},
				# TODO: Trun Timmmy around and delay .5 seconds
				{name = "Timmy", text = "It looks radical, man!!", options = {"THANKS!": DIALOG_TYPE.TIMMY_SHIP_3_THANKS, "RADICAL?": DIALOG_TYPE.TIMMY_SHIP_3_RADICAL}}
			]
		DIALOG_TYPE.TIMMY_SHIP_3_THANKS:
			return [
				{name = "Timmy", text = "Hey, no sweat! I'm just speaking the facts."},
				{queue = DIALOG_TYPE.TIMMY_SHIP_VAULT}
			]
		DIALOG_TYPE.TIMMY_SHIP_3_RADICAL:
			return [
				{name = "Timmy", text = "What? You've never heard anyone say radical before?"},
				{name = "Timmy", text = "That's insulting, man. I'm gonna pretend I didn't hear that."},
				{queue = DIALOG_TYPE.TIMMY_SHIP_VAULT}
			]
		DIALOG_TYPE.TIMMY_SHIP_VAULT:
			return [
				{name = "Timmy", text = "One question, though."},
				# Pan over to time vault sequence
				{signal = "action3", delay=1},
				{name = "Timmy", text = "What's that?"},
				# Walk to Time Piece
				{signal = "action4", delay=0.5},
				{signal = "action5", delay=0.75},
				{name = "Timmy", text = "Looks like some kinda big vault... what do ya keep in here, anyway?"},
				# TODO: Hat Kid explaining animation
				{name = "Timmy", text = "Woah! Time Pieces??"},
				{name = "Timmy", text = "I've heard so much about these! And you have a whole vault of them!?"},
				{name = "Timmy", text = "I wanna have a peek!"},
				# TODO: Open up vault and floats upwards
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
				{signal = "actionK", delay=0.1},
				{name = "Timmy", text = "What? You've never seen someone use psychic powers before?"},
				# Bounce Hat Kid towards Timmy, bounce Timmy away, holding back the TimePiece
				{signal = "actionG", delay=0.1},
				{signal = "actionH", delay=0.75},
				{name = "Timmy", text = "Yo, what's the rush? You got a hot date with this Piece or something?"},
				{name = "Timmy", text = "I'll take as much time as I wanna! Buzz off!"},
				# Bounce Hat Kid towards Timmy
				{signal = "actionG", delay=0.075},
				{signal = "actionH", delay=0.1},
				# Timmy lifts up Hat up
				{signal = "action6", delay=0.2},
				{name = "Timmy", text = "Hey! Didn't your mom ever teach you that 'sharing is caring?'"},
				{name = "Timmy", text = "If you're gonna be greedy, then I'll just steal all of them!"},
				# Camera release and throw
				# Animate hat kid hurt animation
				{animate1 = "hurt_basic"},
				{signal = "action7", delay=2},
				{name = "Timmy", text = "Alright Lil'ens! Come on in!"},
				# Screen shake
				{signal = "actionE", delay=1},
				# Lil'ens enter and walk to vault
				{signal = "action9", delay=2},
				# Dust cloud
				{signal = "actionF", delay=3},
				# Turn off dust cloud and walk Eltuns (now carrying timepieces) to door
				# Move Timmy towards door
				{signal = "actionA", delay=2},
				# Say words
				{name = "Timmy", text = "Keeping all these Time Pieces to yourself is mondo uncool."},
				{name = "Timmy", text = "So as the ruler of this world, I'll take them off your hands! It's only fair for trespassing."},
				{name = "Timmy", text = "Smell ya later stinky!"},
				# Timmy Leave
				{signal = "actionB"},
				{name = "Timmy", text = "Hahahahahahahahahaha!!"},
				{delay=1},
				# Hat Kid Jump up
				{signal = "actionC", delay=1},
				# Hat Kid walk towards door
				{signal = "actionD", delay=0.5},
				# Goto 1
				{level = "res://world1/level1.tscn"}
			]
