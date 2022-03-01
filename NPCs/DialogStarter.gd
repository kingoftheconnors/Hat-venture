# Dialog Starter functionality for talking with NPCs
# and scenery in-game. When the Area2D this is attached to
# is intersecting with the player and the player presses "up"
# the dialog will be queued in the GUI.
extends Node

## Dialog text box number from the gui/game_dialog file
export(game_dialog.DIALOG_TYPE) var dialog_num
## Array of bodies that should remain mobile during dialog
export(Array, NodePath) var active_bodies_in_dialog
## If true, this dialog will only happen once before destroying itself
export(bool) var one_shot
## If true, this dialog is currently active (set false if dialog will be activated later)
export(bool) var enabled = true
## If true, this dialog will automatically run when the scene is loaded
export(bool) var start_on_load = false
## Tag name that, if true, will make this dialog unusable
export(String) var enabled_if_tag_false = ""
## Whether to unfreeze player after dialog. For changing scenes, we don't
## want the player actionable while the level is swapping
export(bool) var unfreeze_after_dialog = true

func queue_dialog(player_body = null):
	queue_dialog_by_id(dialog_num, player_body)
func queue_dialog_by_id(dialog_id, player_body = null):
	# Setup bodies that should move in this dialog
	var active_bodies := []
	if player_body:
		active_bodies.append(player_body)
	for path in active_bodies_in_dialog:
		active_bodies.append(get_node(path))
	# Add command to unfreeze active bodies in dialog
	Gui.queue_text(self, {"enable": active_bodies})
	if player_body:
		Gui.queue_text(self, {"freeze_player": player_body})
	# Queue dialog
	Gui.queue_dialog(self, dialog_id)
	# Re-freeze bodies so next dialog won't have them doing whatevs
	if player_body and unfreeze_after_dialog:
		Gui.queue_text(self, {"unfreeze_player": player_body})
	Gui.queue_text(self, {"disable": active_bodies})
	if one_shot:
		Gui.queue_text(self, {"queue_free": self})

func animate1(animation_name : String):
	get_node(animate1).animate(animation_name)
func animate2(animation_name : String):
	get_node(animate2).animate(animation_name)

func animate1_method_true(function_name : String):
	return get_node(animate1).call(function_name)
func animate2_method_true(function_name : String):
	return get_node(animate2).call(function_name)

func set_dialog_option(dialog_id : int):
	dialog_num = dialog_id

func enable():
	enabled = true

func _ready():
	if enabled_if_tag_false != "":
		if SaveSystem.access_data().get_tag(enabled_if_tag_false) == null \
			or SaveSystem.access_data().get_tag(enabled_if_tag_false) == false:
			enabled = true
		else:
			enabled = false
	if start_on_load and enabled:
		var players : Array = get_tree().get_nodes_in_group("player_root")
		if players != null and players.size() > 0:
			queue_dialog(players[0])
		else:
			queue_dialog(null)

## Signals called by dialog system.
## Connect using the Node tab while inspecting a dialogStarter node
## Can call any method on any other node in the scene
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
# warning-ignore:unused_signal
signal action1; signal action2; signal action3; signal action4;
signal action5; signal action6; signal action7; signal action8;
signal action9; signal actionA; signal actionB; signal actionC;
signal actionD; signal actionE; signal actionF; signal actionG;
signal actionH; signal actionJ; signal actionK; signal actionL;
signal actionM; signal actionN; signal actionO; signal actionP;
signal actionQ; signal actionR; signal actionS; signal actionT;

export(NodePath) var animate1
export(NodePath) var animate2
