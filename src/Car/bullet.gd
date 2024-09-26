extends Area2D
class_name BULLET

var dir =  Vector2.ZERO
var speed = 10

var enemy: Enemy = null
@onready var smoketrail = $Smoketrail
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d_2 = $Sprite2D2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if dir != Vector2.ZERO:
		var velocity = dir*speed
		smoketrail.add_point(global_position)
		global_position += velocity
		

func set_direction(direction: Vector2):
	dir = direction


func _on_kill_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.has_method("handle_hit"):
		body.handle_hit()
		smoketrail.stop()
		sprite_2d_2.visible = true
		animation_player.play("explosion")
		queue_free()
