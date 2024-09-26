extends Line2D

@export var limited_lifetime:bool = false 
@export var wildness = 3.0
@export var gradient_col : Gradient = Gradient.new()

var min_spawn_distance = 10
var gravity = Vector2.UP
var lifetime = [1.0,2.0]
var tick_speed = 0.05
var tick = 0.0
var wild_speed = 0.1

var point_age = [0.0]

func _ready():
	gradient = gradient_col
	set_as_top_level(true)
	clear_points()
	if limited_lifetime:
		stop()
	
func stop():
	var tween = create_tween()
	tween.tween_property(self,"modulate:a",0.0,randf_range(lifetime[0],lifetime[1])).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	
func _process(delta):
	if tick>tick_speed:
		tick = 0
		for p in range(get_point_count()):
			var rand_vector = Vector2(randf_range(-wild_speed,wild_speed),randf_range(-wild_speed,wild_speed))
			
			points[p] += gravity+(rand_vector*wildness*point_age[p])
	else:
		tick+= delta 
		
#func add_point(point_pos:Vector2,at_pos = -1):
	#if get_point_count() > 0 and point_pos.distance_to(points[get_point_count()-1]) < min_spawn_distance:
		#return
func add_point(point_pos: Vector2, at_pos := -1):
	if get_point_count() > 0 and point_pos.distance_to(points[get_point_count() - 1]) < min_spawn_distance:
		return
	point_age.append(0.0)
	add_point(point_pos, at_pos)
	
func _on_Tween_tween_all_completed():
	queue_free()
