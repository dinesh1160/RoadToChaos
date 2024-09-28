extends CharacterBody2D
class_name Car

#signal fired_bullet(bullet, position,direction)

var health = 30  #put it in the gamemanager

@onready var animation_player = $AnimationPlayer
@export var Bullet : PackedScene
@onready var end_of_gun = $EndOfGun
@onready var boost_timer = $Boost_timer
@onready var powerup_timer = $powerup_timer


var triple_power: bool = false
@onready var target = $target
@onready var target2 = $target2
@onready var target3 = $target3



var wheel_base = 30  # Distance from front to rear wheel
var steering_angle = 15  # Amount that front wheel turns, in degrees
var engine_power = 1000  # Forward acceleration force.
var friction = -55
var drag = -0.06
var braking = -450
#var max_speed_reverse = 300
var slip_speed = 400  # Speed where traction is reduced
var traction_fast = 2.0


 # High-speed traction
var traction_slow = 10  #Low-speed traction

var acceleration = Vector2.ZERO
var steer_direction
var can_boost = true

func _physics_process(delta):
	acceleration = Vector2.ZERO
	vibration()
	get_input()
	apply_friction(delta)
	calculate_steering(delta)
	velocity += acceleration * delta
	move_and_slide()


	
func get_input():
	var turn = Input.get_axis("left", "right")
	steer_direction = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("front"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("back"):
		acceleration = transform.x * braking
	if can_boost == true:
		if Input.is_action_pressed("boost"):
			can_boost = false
			boost_timer.start()
			print("boost")
			acceleration = transform.x * (engine_power+30000)
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force


func calculate_steering(delta):
	# 1. Find the wheel positions
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	# 2. Move the wheels forward
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	# 3. Find the new direction vector
	var new_heading = (front_wheel - rear_wheel).normalized()
	# 4. Set the velocity and rotation to the new direction
	
	# choose which traction value to use - at lower speeds, slip should be low
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)
	if d < 0:
		velocity = -new_heading * velocity.length()
	rotation = new_heading.angle()

func vibration():
	if animation_player.current_animation == "vibrate":
		return
	else:
		animation_player.play("vibrate")
	
#func _unhandled_input(event):
	#if Input.is_action_just_pressed("shoot"):
		#shoot()
	
func triple_shoot():
	var bullet_instance = Bullet.instantiate()
	var direction = end_of_gun.global_position.direction_to(target.global_position).normalized()  #finds the direction using another marker2d called target
	Signalmanager.emit_signal("fired_bullet",bullet_instance,end_of_gun.global_position,direction)
	
	var bullet_instance2 = Bullet.instantiate()
	var direction2 = end_of_gun.global_position.direction_to(target2.global_position).normalized()  #finds the direction using another marker2d called target
	Signalmanager.emit_signal("fired_bullet",bullet_instance2,end_of_gun.global_position,direction2)
	
	var bullet_instance3 = Bullet.instantiate()
	var direction3 = end_of_gun.global_position.direction_to(target3.global_position).normalized()  #finds the direction using another marker2d called target
	Signalmanager.emit_signal("fired_bullet",bullet_instance3,end_of_gun.global_position,direction3)
	
	
func shoot():
	if triple_power == true:
		triple_shoot()
	else:
		var bullet_instance = Bullet.instantiate()
		var direction = end_of_gun.global_position.direction_to(target.global_position).normalized() 
		Signalmanager.emit_signal("fired_bullet",bullet_instance,end_of_gun.global_position,direction)

func handle_hit():
	health -= 1
	if health<=0:
		queue_free()
	print(health)
	
	
func _on_boost_timer_timeout():
	can_boost = true


func _on_hitbox_area_entered(area):
	if area.is_in_group("bullet"):
		handle_hit()
		area.bullet_hit()
		
	
func size_powerup():
	var x_values = [-0.5, 1.5 , 3]
	var y_values = [-0.5, 1.5 , 3]
	var random_x = x_values[randi() % x_values.size()]
	var random_y = y_values[randi() % x_values.size()]
	powerup_timer.start()
	scale = Vector2(random_x,random_y)
	
func triple_powerup():
	triple_power = true
	powerup_timer.start()
	
func _on_powerup_timer_timeout():
	print("timeout")
	if scale != Vector2(1,1):
		scale = Vector2(1,1)
	triple_power = false
	
