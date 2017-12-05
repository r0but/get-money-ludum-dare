extends Area2D

func _ready():
	pass


func _on_exitdoor_body_enter( body ):
	if body.is_in_group("player"):
		body.leave_level()
