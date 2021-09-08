extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print(SaveSystem.access_data().get_tag("satellite_aligned"))
	print(SaveSystem.access_data().get_tag("timepieces_stolen"))
	if SaveSystem.access_data().get_tag("satellite_aligned") == null \
		or SaveSystem.access_data().get_tag("timepieces_stolen") == null:
		$Exclamation.visible = true
	else:
		$TimePieces.visible = true
		$DialogBox.enabled = false

func pressed():
	if SaveSystem.access_data().get_tag("satellite_aligned") == null:
		$Exclamation.visible = false
		$TimePieces.visible = true
		# TODO: Play sfx
		print("Starting new dialog")
		$DialogBox.queue_dialog_by_id(game_dialog.DIALOG_TYPE.SHIP_SCREEN_1)
	elif SaveSystem.access_data().get_tag("timepieces_stolen") == null:
		$Exclamation.visible = false
		$TimePieces.visible = true
		# TODO: Play sfx
		$DialogBox.queue_dialog_by_id(game_dialog.DIALOG_TYPE.SHIP_SCREEN_2)

func set_to_exclamation():
	$Exclamation.visible = true
	$TimePieces.visible = false
