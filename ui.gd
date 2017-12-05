extends CanvasLayer

func _ready():
	pass

func set_score(new_score):
	get_node("score").set_text("$" + str(new_score))
