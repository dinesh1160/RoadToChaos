extends Area2D
@onready var effect_timer = $effect_timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("car"):
		Signalmanager.emit_signal("laugh_powerup")
		queue_free()
