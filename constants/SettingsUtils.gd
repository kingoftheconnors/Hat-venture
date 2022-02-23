extends Node

func get_parsed_string(template_text) -> String:
	var parsed_text = (
		template_text \
			.replace("{jump}", OS.get_scancode_string(ggsManager.settings_data["12"].current.value)) \
			.replace("{action}", OS.get_scancode_string(ggsManager.settings_data["13"].current.value)) \
			.replace("{release}", OS.get_scancode_string(ggsManager.settings_data["20"].current.value))
			)
	return parsed_text
