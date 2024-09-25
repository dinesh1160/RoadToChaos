extends Node2D

@onready var car = $Car
@onready var bullet_manger = $BulletManger
@onready var manmy = $Manmy

func _ready() -> void:
	randomize()
	Signalmanager.fired_bullet.connect(Callable(bullet_manger, "handle_bullet_spawned"))
	
