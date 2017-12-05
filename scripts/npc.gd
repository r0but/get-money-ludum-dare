extends KinematicBody2D

const TIME_BETWEEN_REPATHING = .2 # seconds
const CLOSE_ENOUGH = 5

var target_coords = Vector2(0, 0)
var path_to_target = []
var speed = 75
var time_to_repath = .2

var startled = false

var bouncing_back = true
var bounceback_speed = 600
var bounceback_time_total = .125
var bounceback_time = 0
var hit_direction = Vector2(0, 0)

var hit_flash_duration = bounceback_time_total + (bounceback_time_total * .05)

export var chase_threshold = 2

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if not bouncing_back:
		normal_move(delta)
	else:
		knockback_movement(delta)
	draw_path()

func normal_move(delta):
	target_coords = get_target()
	time_to_repath += delta
	if time_to_repath >= TIME_BETWEEN_REPATHING:
		find_target()
		time_to_repath = 0
	update_path()
	move_to_target(delta)

func trigger_knockback():
	bouncing_back = true
	hit_direction = get_global_pos() - get_node("../player").get_global_pos()

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

# Figure out where to go
func find_target():
	path_to_target = get_node("../Navigation2D").get_simple_path(get_global_pos(), target_coords, false)
	pass

func is_in_fov(target_coords):
	pass

# Figure out what the target should be
func get_target():
	if not startled:
		var world_space = get_world_2d().get_direct_space_state()
		var cast = world_space.intersect_ray(get_global_pos(), get_node("../player").get_global_pos(), get_tree().get_nodes_in_group("enemy") + get_tree().get_nodes_in_group("money"))
		
		if cast.empty():
			return target_coords
		elif cast.collider == get_node("../player") and get_node("../player").money > chase_threshold:
			startled = true
	
	if startled:
		return get_node("../player").get_global_pos()
	else:
		return target_coords

func update_path():
	if path_to_target.size() > 0:
		var distance = get_global_pos().distance_to(path_to_target[0])
		if distance <= CLOSE_ENOUGH:
			path_to_target.remove(0)

func move_to_target(delta):
	if path_to_target.size() > 0:
		var path = path_to_target[0] - get_global_pos()
		var direction = path.normalized()
		var move_vector = move(direction * delta * speed)
		if (is_colliding()):
			if get_collider().get_name().casecmp_to("exit-door") == 0:
				queue_free()
				return
			var normal = get_collision_normal()
			move_vector = normal.slide(move_vector)
			move(move_vector)
	return

func draw_path():
	#update()
	pass

func _draw():
	if path_to_target.size() >= 1:
		for p in path_to_target:
			draw_circle(p - get_global_pos(), 3, Color(1, 1, 1))

func _on_Area2D_body_enter( body ):
	if body.is_in_group("player"):
		body.take_hit(get_global_pos())
	pass
