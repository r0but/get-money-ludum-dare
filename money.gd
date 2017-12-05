extends KinematicBody2D

var value = 1

var momentum_vector = Vector2(0, 0)
var moving = false
var crisp = true

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if momentum_vector.length() > 2:
		
		var move_vector = move(momentum_vector * delta)
		if is_colliding():
			move_vector = get_collision_normal().slide(move_vector)
			move(move_vector)
		
		momentum_vector *= .75
	else:
		momentum_vector = Vector2(0, 0)
		moving = false

func set_momentum(speed):
	var angle = rand_range(-3.14159, 3.14159)
	momentum_vector = Vector2(cos(angle), sin(angle)) * speed
	moving = true
	crisp = false

func _on_money_body_enter( body ):
	if body.is_in_group("player") and not moving:
		body.take_money(value)
		
		if crisp:
			get_node("..").money_collected()
		
		queue_free()
	pass
