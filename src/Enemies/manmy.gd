extends CharacterBody2D

signal enemy_fired_bullet(bullet, position,direction)
@export var Bullet : PackedScene
@export var Car : PackedScene
@onready var endpoint = $endpoint

var health = 5
var patrole

@onready var attackzone = $attackzone

func handle_hit():
	health -= 1
	if(health<=0):
		queue_free()
	print(health)

func _on_area_2d_body_entered(body):
	health = 0
	handle_hit()

func shoot():
	var bullet_instance = Bullet.instantiate()
	var car_instance = Car.instantiate()
	var direction = endpoint.global_position.direction_to(car_instance.global_position).normalized() #finds the direction using another marker2d called target
	
	emit_signal("enemy_fired_bullet",bullet_instance,endpoint.global_position,direction)
	
func _on_attackzone_body_entered(body):
	patrole = false
	shoot()
	
