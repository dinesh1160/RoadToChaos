extends Node2D

@onready var car = $Car
@onready var bullet_manger = $BulletManger
@onready var manmy = $Manmy
@onready var game = $"."


func _ready() -> void:
	randomize()
	Signalmanager.fired_bullet.connect(Callable(bullet_manger, "handle_bullet_spawned"))
	Signalmanager.laugh_powerup.connect(Callable(game, "laugh_powerup"))
	Signalmanager.size_powerup.connect(Callable(car, "size_powerup"))
	
	
	Signalmanager.powerup_reset.connect(Callable(car, "powerup_reset"))

func laugh_powerup():
	print("laugh")
