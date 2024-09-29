extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation = delta*2


func _on_body_entered(body):
	if body.is_in_group("car"):
		Signalmanager.emit_signal("size_powerup")
		queue_free()
