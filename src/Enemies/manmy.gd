extends CharacterBody2D
var health = 5

func handle_hit():
	health -= 1
	if(health<=0):
		queue_free()
	print(health)
