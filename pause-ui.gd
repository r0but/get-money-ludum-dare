extends CanvasLayer

func _ready():
	get_tree().set_pause(true)
	get_node("continue").grab_focus()

func _on_continue_pressed():
	get_tree().set_pause(false)
	get_node("/root/game").unpause_game()

func _on_restart_pressed():
	get_node("/root/game").restart()
	get_tree().set_pause(false)

func _on_mainmenu_pressed():
	get_tree().change_scene("res://main-menu.tscn")
	get_tree().set_pause(false)
