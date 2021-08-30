extends Node
# value: bool
#	Whether the bus is muted or not.
# bus_name: String
#	The name of the bus that'll be affected


func main(value: Dictionary) -> void:
	var bus_index: int = AudioServer.get_bus_index(value["bus_name"])
	AudioServer.set_bus_mute(bus_index, value["value"])
