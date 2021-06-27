
class_name game_dialog

enum DIALOG_TYPE {
	TEMPLATE_1,
	TEMPLATE_2,
	GOTO_TUTORIAL,
	GOTO_SHIP,
	GOTO_WORLD_1,
	DIVE_TUTORIAL,
	SATELLITE
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
				{name = "Sign", text = "Little girls can dive over large gaps using the " + OptionsMenu.get_keyname("ui_B") + " (action) button!"}
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
		DIALOG_TYPE.GOTO_SHIP:
			return [
				{level = "res://level-select/ship.tscn"}
			]
		DIALOG_TYPE.GOTO_WORLD_1:
			return [
				{level = "res://world1/level1.tscn"}
			]
