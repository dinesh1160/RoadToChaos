extends CharacterBody2D

class_name Enemy

@onready var attack_timer = $Attack_timer

signal enemy_fired_bullet(bullet, position,direction)
@export var Bullet : PackedScene
#@export var Cars : PackedScene
@onready var endpoint = $endpoint
var car:Car = null   #car injuction

var health = 5
var engage = false
var can_attack = true

func _ready():
	pass
	
func _physics_process(delta):
	if engage and car!=null:
		rotation = global_position.direction_to(car.global_position).angle()
		if can_attack:
			shoot()

func handle_hit():
	health -= 1
	if(health<=0):
		queue_free()
	print(health)

func _on_area_2d_body_entered(body):
	if body.is_in_group("car"):
		health = 0
		handle_hit()

func shoot():
	can_attack = false
	var bullet_instance = Bullet.instantiate()
	var direction = endpoint.global_position.direction_to(car.global_position).normalized() #finds the direction using another marker2d called target
	emit_signal("enemy_fired_bullet",bullet_instance,endpoint.global_position,direction)
	attack_timer.start()

func _on_player_dectection_body_entered(body): #to detect the car in range
	if body.is_in_group("car"):
		engage = true
		car = body
		

func _on_player_dectection_body_exited(body): #to detect the car out of range
	if body.is_in_group("car"):
		engage = false
		car = null

func _on_attack_timer_timeout():
	can_attack = true
