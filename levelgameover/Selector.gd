extends TextureRect

enum SELECTOR_STATE {CONTINUE, QUIT}
var state = SELECTOR_STATE.CONTINUE

onready var animator = $AnimationPlayer

func _unhandled_input(event):
	if event.is_action_pressed("ui_A"):
		if state == SELECTOR_STATE.CONTINUE:
			PlayerGameManager.start_level("1")
		if state == SELECTOR_STATE.QUIT:
			get_tree().quit()
			
	if event.is_action_pressed("ui_up"):
		state = SELECTOR_STATE.CONTINUE
		animator.play("continue")
	if event.is_action_pressed("ui_down"):
		state = SELECTOR_STATE.QUIT
		animator.play("quit")
