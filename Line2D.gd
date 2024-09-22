extends Line2D

var point
func _ready():
	top_level =true
	
func _physics_process(delta):
	point = get_parent().global_position
	add_point(point)
	if points.size()>500:
		remove_point(0)
