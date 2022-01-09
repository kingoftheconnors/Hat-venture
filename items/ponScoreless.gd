extends pon
class_name scoreless_pon

func collect_as_item(_body, _this):
	# Update GUI
	PlayerGameManager.add_pons(1)
	return true
