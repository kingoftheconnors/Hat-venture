extends Node

var wonBosses = []
var upgrades = ["shadow_visor", "spectral_visor"]
# Upgrade Types:
#   spectral_visor: Basic spectral view (pressing D)
#      Makes player a ghost with the ability to float
#   shadow_visor: Special shadow view (pressing S)
#      Makes player squishy shadow that can climb walls
#	healthjar_1,2,3,...: health upgrades

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load save data
	pass # Replace with function body.

func save():
	# Save data
	pass

func checkpoint():
	# Set checkpoint and automatically save
	pass

func upgrade_unlocked(upgrade):
	return upgrades.has(upgrade)

func unlock(upgrade, updateGUI = false):
	upgrades.push_back(upgrade)
	if updateGUI:
		get_tree().call_group("ui", "refresh")
