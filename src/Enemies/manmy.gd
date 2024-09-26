extends CharacterBody2D

class_name Enemy

@onready var attack_timer = $Attack_timer
@onready var patrol_timer = $Patrol_timer

@export var Bullet : PackedScene
@onready var endpoint = $endpoint
var car:Car = null   #car injuction

var health = 5
var engage = false
var can_attack = true
var can_patrol = true

#patrol
var origin : Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var manmy_velocity: Vector2 = Vector2.ZERO
var patrol_location_reached:bool = false


func _ready():
	velocity = Vector2(4,0)
	
func _physics_process(delta):

	if !engage and can_patrol == true:
		if not patrol_location_reached:
			velocity = manmy_velocity
			move_and_slide()
			rotation = lerp(rotation,global_position.direction_to(patrol_location).angle(),0.2) 
			if global_position.distance_to(patrol_location) < 5:
				patrol_location_reached = true
				velocity = Vector2.ZERO
				patrol_timer.start()

	if engage and car!=null:
		rotation = lerp(rotation,global_position.direction_to(car.global_position).angle(),0.2)
		if can_attack:
			shoot()

func handle_hit():
	
	health -= 1
	if(health<=0):
		queue_free()
	print(health)
	
	
func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		handle_hit()
		area.bullet_hit()

func _on_area_2d_body_entered(body):
	if body.is_in_group("car"):
		health = 0
		handle_hit()
	

func shoot():
	can_attack = false
	var bullet_instance = Bullet.instantiate()
	var direction = endpoint.global_position.direction_to(car.global_position).normalized() #finds the direction using another marker2d called target
	Signalmanager.emit_signal("fired_bullet",bullet_instance,endpoint.global_position,direction)
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


func _on_patrol_timer_timeout():
	var patrol_range = 70
	var random_x = randf_range(-patrol_range,patrol_range)
	var random_y = randf_range(-patrol_range,patrol_range)
	patrol_location = Vector2(random_x,random_y)+ origin
	patrol_location_reached = false
	manmy_velocity = global_position.direction_to(patrol_location)*100
	can_patrol = true


