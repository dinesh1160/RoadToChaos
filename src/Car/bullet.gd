extends Area2D
class_name BULLET

var dir =  Vector2.ZERO
@export var speed = 10

var enemy: Enemy = null

@onready var smoketrail = $Smoketrail
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d_2 = $Sprite2D2
@onready var hit_vanish_timer = $Hit_vanish_timer
@onready var bullet_sound = $BulletSound


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dir != Vector2.ZERO:
		var velocity = dir*speed
		smoketrail.add_point(global_position)
		global_position += velocity
		
func _ready():	
	bullet_sound.play() 

func set_direction(direction: Vector2):
	dir = direction


func _on_kill_timer_timeout():
	queue_free()

func bullet_hit():
	smoketrail.stop()
	speed = 0
	animation_player.play("explosion")
	hit_vanish_timer.start()
	
func _on_hit_vanish_timer_timeout():
	queue_free()
	


func _on_body_entered(body):
	if body.is_in_group("walls"):
		bullet_hit()
