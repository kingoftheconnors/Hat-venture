extends Node
# value: int
#	Index of one of the items in the 'resolution_list'.

var options_list: Array = [
	Constants.SKIP_TYPE.RUN,
	Constants.SKIP_TYPE.SKIP,
	Constants.SKIP_TYPE.WORDLESS
]

func main(value: Dictionary) -> void:
	Constants.SKIP_CUTSCENES = options_list[value["value"]]
