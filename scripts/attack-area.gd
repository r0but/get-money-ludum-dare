extends Area2D

const ROTATION_MOD = - 1.570795

var total_duration = .05
var OFFSET = 6
var direction = Vector2(0, 0)

var duration = 0
var attacker

func init_state(atk_direction, atk_node):
	direction = atk_direction
	attacker = atk_node
	total_duration = attacker.atk_duration
	
	set_global_pos(direction * OFFSET + attacker.get_global_pos())
	set_rot(direction.angle() + ROTATION_MOD)

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	set_global_pos(direction * OFFSET + attacker.get_global_pos())
	for body in get_overlapping_bodies():
		if body.has_method("trigger_knockback"):
			body.trigger_knockback()
	
	duration += delta
	if duration >= total_duration:
		queue_free()