extends CharacterBody2D
class_name Car

#signal fired_bullet(bullet, position,direction)

var health = 30  #put it in the gamemanager

@onready var animation_player = $AnimationPlayer
@export var Bullet : PackedScene
@onready var end_of_gun = $EndOfGun
@onready var target = $target

var wheel_base = 60  # Distance from front to rear wheel
var steering_angle = 15  # Amount that front wheel turns, in degrees
var engine_power = 1000  # Forward acceleration force.
var friction = -55
var drag = -0.06
var braking = -450
#var max_speed_reverse = 300
var slip_speed = 400  # Speed where traction is reduced
var traction_fast = 2.0


 # High-speed traction
var traction_slow = 10  # Low-speed traction

var acceleration = Vector2.ZERO
var steer_direction

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
	
func _unhandled_input(event):
	if Input.is_action_just_pressed("shoot"):
		shoot();
	
	
func shoot():
	var bullet_instance = Bullet.instantiate()
	var direction = end_of_gun.global_position.direction_to(target.global_position).normalized() #finds the direction using another marker2d called target
	
	Signalmanager.emit_signal("fired_bullet",bullet_instance,end_of_gun.global_position,direction)

func handle_hit():
	health -= 1
	if health<=0:
		queue_free()
	print(health)
