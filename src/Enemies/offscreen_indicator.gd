extends Node2D

@onready var arrow_sprite = $Arrow_sprite


func _physics_process(delta):
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin/canvas.get_scale()
	var size = get_viewport_rect().size/ canvas.get_scale()
	
	set_marker_position(Rect2(top_left,size))
	set_marker_rotation()
	
func set_marker_position(bounds: Rect2):
	arrow_sprite.global_position.x = clamp(global_position.x,bounds.position.x,bounds.end.x)
	arrow_sprite.global_position.y = clamp(global_position.y,bounds.position.y,bounds.end.y)
	
	if bounds.has_point(global_position):
		hide()
	else:
		show()
		
func set_marker_rotation():
	var angle = (global_position - arrow_sprite.global_position).angle()
	arrow_sprite.global_rotation = angle
	
