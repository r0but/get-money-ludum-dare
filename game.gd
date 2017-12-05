extends Node2D

onready var ui_node = preload("res://ui.tscn").instance()
onready var gameover_node = preload("res://gameover-ui.tscn").instance()
onready var pause_node = preload("res://pause-ui.tscn").instance()

var paused = false

func _ready():
	randomize()
	add_child(ui_node)
	pass

func pause_game():
	add_child(pause_node)

func unpause_game():
	remove_child(pause_node)

func update_score(new_score):
	ui_node.set_score(new_score)

func end_game(money, exit_type = "leave"):
	gameover_node.set_score(money, exit_type)
	add_child(gameover_node)

func restart():
	get_tree().reload_current_scene()
