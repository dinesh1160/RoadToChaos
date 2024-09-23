extends Area2D

var dir =  Vector2.ZERO
var speed = 60
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dir != Vector2.ZERO:
		var velocity = dir*speed
		
		global_position += velocity
		

func set_direction(direction: Vector2):
	dir = direction
