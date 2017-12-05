extends CanvasLayer

func _ready():
	get_tree().set_pause(true)
	get_node("restart").grab_focus()

func set_score(score, exit_type = "leave"):
	if exit_type == "leave":
		if score == 0:
			get_node("score-label").set_text("You got no bucks. Try to get a couple next time!")
		elif score == 1:
			get_node("score-label").set_text("You got a buck!\n\nDon't spend it all in one place.")
		else:
			get_node("score-label").set_text("You got " + str(score) + " bucks!\n\nDon't spend it all in one place.")
	elif exit_type == "lose":
		get_node("score-label").set_text("You lost everything.\n\nTry to make it to the exit.")

func _on_restart_pressed():
	get_node("/root/game").restart()
	get_tree().set_pause(false)

func _on_mainmenu_pressed():
	get_tree().change_scene("res://main-menu.tscn")
	get_tree().set_pause(false)
