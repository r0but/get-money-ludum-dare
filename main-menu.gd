extends CanvasLayer

func _ready():
	get_node("apartments").grab_focus()

func _on_level_1_pressed():
	get_tree().change_scene("res://rec-center.tscn")

func _on_apartments_pressed():
	get_tree().change_scene("res://apartments.tscn")

func _on_exit_pressed():
	get_tree().quit()

