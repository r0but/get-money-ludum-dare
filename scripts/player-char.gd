extends KinematicBody2D

var BASE_SPEED = 125
var ATK_SCENE

var atk_duration = .05
var atk_delay = .2
var atk_timer = atk_duration + atk_delay

var money = 0

var bouncing_back = false
var bounceback_speed = 600
var bounceback_time_total = .125
var bounceback_time = 0
var iframes = false
var itime_max = 1
var itime = 0
var hit_direction = Vector2(0, 0)

func _ready():
	set_fixed_process(true)
	ATK_SCENE = preload("res://attack-area.tscn")
	pass

func _fixed_process(delta):
	if Input.is_action_pressed("ui_pause"):
		get_node("/root/game").pause_game()
	
	#atk_timer += delta
	#var atk_dir = take_attack_input()
	#attack(atk_dir)
	
	var move_vector = take_movement_input()
	
	if itime <= itime_max and iframes:
		itime += delta
	else:
		itime = 0
		iframes = false
	
	if not bouncing_back:
		move_character(delta, move_vector)
	else:
		knockback_movement(delta)

func move_character(delta, move_vector):
	var speed = BASE_SPEED
	move_vector = move(move_vector * delta * speed)
	
	if (is_colliding()):
		if get_collider().is_in_group("enemy"):
			take_hit(get_collider().get_global_pos())
		
		var normal = get_collision_normal()
		move_vector = normal.slide(move_vector)
		move(move_vector)

func knockback_movement(delta):
	if bounceback_time < bounceback_time_total:
		bounceback_time += delta
		var move_vector = move(hit_direction.normalized() * bounceback_speed * delta)
		if is_colliding():
			move_vector = get_collision_normal().slide(move_vector)
			move(move_vector)
	else:
		bounceback_time = 0
		bouncing_back = false
		hit_direction = Vector2(0, 0)

func attack(atk_dir):
	if atk_dir.length() >= .1 and atk_timer >= atk_duration + atk_delay:
		var atk_node = ATK_SCENE.instance()
		atk_node.init_state(atk_dir, self)
		get_node("..").add_child(atk_node)
		atk_timer = 0

func take_attack_input():
	var atk_direction = Vector2(0, 0)
	if Input.is_action_pressed("pc_atk_up"):
		atk_direction.y -= 1
	elif Input.is_action_pressed("pc_atk_down"):
		atk_direction.y += 1
	elif Input.is_action_pressed("pc_atk_right"):
		atk_direction.x += 1
	elif Input.is_action_pressed("pc_atk_left"):
		atk_direction.x -= 1
	return atk_direction.normalized()

func take_movement_input():
	var move_vector
	var analog_vector = Vector2(Input.get_joy_axis(0, JOY_AXIS_0), 
		                        Input.get_joy_axis(0, JOY_AXIS_1))
	if analog_vector.length() < .2:
		move_vector = digital_movement()
	else:
		move_vector = analog_vector
	
	if Input.is_action_pressed("pc_run"):
		move_vector *= 1.75
	
	return move_vector

func digital_movement():
	var move_vector = Vector2(0, 0)
	if Input.is_action_pressed("pc_down"):
		move_vector.y += 1
	if Input.is_action_pressed("pc_up"):
		move_vector.y -= 1
	if Input.is_action_pressed("pc_right"):
		move_vector.x += 1
	if Input.is_action_pressed("pc_left"):
		move_vector.x -= 1
	move_vector = move_vector.normalized()
	
	return move_vector

func drop_dollar():
	var dollar_scn = preload("res://money.tscn").instance()
	dollar_scn.set_pos(get_pos())
	dollar_scn.set_momentum(randi() % 200 + 200)
	dollar_scn.value = 1
	get_node("/root/game/level").add_child(dollar_scn)

func take_hit(collider_pos):
	if money > 0 and not iframes:
		var drop_amount = ceil(money * 0.75)
		take_money(-money)
	
		for i in range(drop_amount):
			drop_dollar()
	
		if not bouncing_back:
			bouncing_back = true
			iframes = true
			hit_direction = (get_global_pos() - collider_pos).normalized()
	elif iframes:
		pass
	else:
		get_node("/root/game").end_game(money, "lose")

func leave_level():
	get_node("/root/game").end_game(money, "leave")

func take_money(value):
	money += value
	get_node("/root/game").update_score(money)
