
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
	TIMMY_SHIP_2 = 11,
	TIMMY_SHIP_3_THANKS = 12,
	TIMMY_SHIP_3_RADICAL = 13,
	TIMMY_SHIP_VAULT_YES = 14,
	TIMMY_SHIP_VAULT_NO1 = 15,
	TIMMY_SHIP_VAULT_NO2 = 16,
	TIMMY_SHIP_VAULT_NO3 = 17,
	TIMMY_SHIP_TIMMY_MAD = 18,
	TIMMY_SHIP_HOMEWRECKING = 19,
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
				{name = "WARNING!", text = "Kids have been known to dive over large gaps using the " + OptionsMenu.get_keyname("ui_B") + " button!"},
				{name = "WARNING!", text = "If you don't know what " + OptionsMenu.get_keyname("ui_B") + " buttons are, call up your radical overlord: Me!"},
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
				{name = "Kid", text = "Yo! You the kid with the Time Pieces? Thought I'd pop in and check 'em out!"},
				{name = "Kid", text = "This is my turf after all."},
				{name = "Timmy", text = "My name's Timmy, and I'm one radical guy!"},
				{name = "Timmy", text = "You mind if I drop in?", options = {"YES": DIALOG_TYPE.TIMMY_SHIP_2, "NO": DIALOG_TYPE.TIMMY_SHIP_2}},
			]
		DIALOG_TYPE.TIMMY_SHIP_2:
			return [
				{name = "Timmy", text = "Tubular!"},
				# Move Timmy to the left and have him look around
				{signal = "action2", delay=1},
				{name = "Timmy", text = "Whoa!! This is your place?"},
				{name = "Timmy", text = "One question, though."},
				# TODO: Walk over to time vault sequence
				{signal = "action3", delay=1},
				{name = "Timmy", text = "What's that?"},
				{signal = "action4", delay=0.5},
				{signal = "action5", delay=0.75},
				{name = "Timmy", text = "Whoa! Time Pieces??"},
				# Lift up
				{signal = "action6", delay=1},
				{name = "Timmy", text = "I'm stealing these, bye."},
				# Camera release and throw
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
				{signal = "actionA", delay=1},
				# Say words
				{name = "Timmy", text = "Toss you later, dork!"},
				# Timmy Leave
				{signal = "actionB", delay=1},
				# Hat Kid Jump up
				{signal = "actionC", delay=1},
				# Hat Kid walk towards door
				{signal = "actionD", delay=0.5},
				# Goto 1
				{level = "res://world1/level1.tscn"}
				#{name = "Timmy", text = "It looks radical, man!", options = {"THANKS": DIALOG_TYPE.TIMMY_SHIP_3_THANKS, "RADICAL?": DIALOG_TYPE.TIMMY_SHIP_3_RADICAL}},
			]
		DIALOG_TYPE.TIMMY_SHIP_3_THANKS:
			return [
				{name = "Timmy", text = "Hey, no sweat! I'm just speaking the facts."},

			]
		DIALOG_TYPE.TIMMY_SHIP_3_RADICAL:
			return [
				{name = "Timmy", text = "What? You've never heard anyone say radical before?"},
				{name = "Timmy", text = "That's insulting, man. I'm gonna pretend I didn't hear that."},
			]
		DIALOG_TYPE.TIMMY_SHIP_VAULT_YES:
			return [
				# Timmy phychic lifting
				# Timmy psychic throwing you
			]
		DIALOG_TYPE.TIMMY_SHIP_VAULT_NO3:
			return [
				# Timmy phychic lifting
				# Timmy psychic throwing you
			]
		DIALOG_TYPE.TIMMY_SHIP_HOMEWRECKING:
			return [
				# Lil'ens entering
				# "Get 'em lil'ens!"
				# Player thrown into wall and blacking out (reset camera)
				# Fade in with Lil'ens running through door
				# Timmy throws timepiece back
				# Timmy runs away
				# Hat Kid runs through door
				# Goto level1
			]
