
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
	SHIP_SCREEN_2 = 9
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
				{signal = "action7", delay=0.5},
				# Play knock sfx
				# Hat Kid question mark
				# Move camera
				{signal = "action2", delay=1},
				# Move hat kid to door
				# Show Timmy and sfx (door becomes open black void)
				# Start dialog options
				# Timmy phychic lifting you
				# Lil'ens entering
				# "Get 'em lil'ens!"
				# Player thrown into wall and blacking out (reset camera)
				# Fade in with Lil'ens running through door
				# Timmy throws timepiece back
				# Timmy runs away
				# Hat Kid runs through door
				# Goto level1
			]
