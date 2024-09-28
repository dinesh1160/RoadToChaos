extends Control

@export var game : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	
func _on_button_pressed():
	get_tree().change_scene_to_packed(game)

func get_input():
	if Input.is_action_just_pressed("boost"):
		get_tree().change_scene_to_packed(game)
		
