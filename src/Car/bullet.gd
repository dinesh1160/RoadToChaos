extends Area2D
class_name BULLET

var dir =  Vector2.ZERO
var speed = 40
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dir != Vector2.ZERO:
		var velocity = dir*speed
		
		global_position += velocity
		

func set_direction(direction: Vector2):
	dir = direction


func _on_kill_timer_timeout():
	queue_free()


func _on_area_entered(area):
	var enemy_body = area.get_parent()
	if enemy_body.has_method("handle_hit"):
		enemy_body.handle_hit()
		queue_free()
