shader_type canvas_item;

// Which color you want to change
uniform vec4 game_white : hint_color;
uniform vec4 game_light : hint_color;
uniform vec4 game_dark : hint_color;
uniform vec4 game_black : hint_color;

uniform vec4 palette_white : hint_color;
uniform vec4 palette_light : hint_color;
uniform vec4 palette_dark : hint_color;
uniform vec4 palette_black : hint_color;

uniform int brightness_level;
uniform float epsilon;

int get_level_from_game_color(vec3 color) {
	if (abs(length(color)-length(game_white.rgb)) <= abs(length(color)-length(game_light.rgb)))
		return 3;
	if (abs(length(color)-length(game_light.rgb)) <= abs(length(color)-length(game_dark.rgb)))
		return 2;
	if (abs(length(color)-length(game_dark.rgb)) <= abs(length(color)-length(game_black.rgb)))
		return 1;
	return 0;
}

vec4 get_palette_color(int level) {
	if (level >= 3)
		return palette_white;
	if (level == 2)
		return palette_light;
	if (level == 1)
		return palette_dark;
	if (level <= 0)
		return palette_black;
	return game_black;
}

void fragment() {
	vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	int level = get_level_from_game_color(c);
	COLOR.rgb = get_palette_color(level+brightness_level).rgb;
}