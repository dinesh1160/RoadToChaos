extends Node2D


func handle_bullet_spawned(bullet:BULLET,position:Vector2,direction:Vector2):
	
	add_child(bullet)
	#bullet.direction = bullet.rotated(randf_range(-0.02,0.02))
	bullet.global_position = position
	bullet.set_direction(direction)
